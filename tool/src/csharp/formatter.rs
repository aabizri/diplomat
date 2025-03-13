// Reference: https://github.com/Cysharp/csbindgen/

use std::borrow::Cow;

use diplomat_core::hir::{
    Docs, DocsUrlGenerator, FloatType, Ident, Int128Type, IntSizeType, IntType, PrimitiveType, ReturnType, StructField, StructPathLike, SuccessType, TyPosition, Type, TypeContext, TypeId
};
use heck::ToLowerCamelCase;

pub(super) struct CSharpFormatter<'tcx> {
    tcx: &'tcx TypeContext,
    docs_url_gen: &'tcx DocsUrlGenerator,
}

impl<'tcx> CSharpFormatter<'tcx> {
    pub fn new(tcx: &'tcx TypeContext, docs_url_gen: &'tcx DocsUrlGenerator) -> Self {
        Self { tcx, docs_url_gen }
    }

    pub fn fmt_type_name_from_str(raw: &str) -> String {

        // C# uses PascalCase for types (except primitives and the like)
        use heck::ToPascalCase;
        let cased = raw.to_pascal_case();

        cased
    }

    pub fn fmt_type_name_from_typedef<'a>(ty: &'a crate::hir::TypeDef<'a>) -> String {
        let base = ty.name().as_str();
        let renamed = ty.attrs().rename.apply(base.into());

        Self::fmt_type_name_from_str(&renamed)
    }

    pub fn fmt_type_name_from_id(&self, id: TypeId) -> String {
        let ty = self.tcx.resolve_type(id);
        
        Self::fmt_type_name_from_typedef(&ty)
    }

    pub fn fmt_function_name(&self, ident: &crate::hir::IdentBuf) -> String {
        use heck::ToPascalCase;
        ident.as_str().to_pascal_case()
    }

    pub fn fmt_function_return_type(&self, ty: &ReturnType) -> Cow<'static, str> {
        match ty {
            ReturnType::Infallible(success_type) => {
                if success_type.is_unit() || success_type.is_write() {
                    "void".into()
                } else {
                    match success_type.as_type() {
                        Some(t) => self.fmt_inner_type(t),
                        None => unreachable!(),
                    }
                }
            }
            ReturnType::Fallible(_, _) | ReturnType::Nullable(_) => {
                let (success_type, error_type) = match ty {
                    ReturnType::Fallible(success_type, error_type) => (success_type, error_type),
                    ReturnType::Nullable(success_type) => (success_type, &None),
                    _ => unreachable!()
                };

                match (success_type, error_type) {
                    (SuccessType::Unit | SuccessType::Write, None) => "DiplomatRuntime::DiplomatResultVoidVoid".into(),
                    (SuccessType::Unit | SuccessType::Write, Some(error_type)) => format!("DiplomatRuntime::DiplomatResultVoidSuccess<{}>", self.fmt_inner_type(error_type)).into(),
                    (SuccessType::OutType(success_type), None) => format!("DiplomatRuntime::DiplomatResultVoidError<{}>", self.fmt_inner_type(success_type)).into(),
                    (SuccessType::OutType(success_type), Some(error_type)) => format!("DiplomatRuntime::DiplomatResult<{}, {}>", self.fmt_inner_type(success_type), self.fmt_inner_type(error_type)).into(),
                    _ => unimplemented!("Combination of success_type {:?} and error_type {:?} not supported", success_type, error_type),
                }
            },
        }
    }

    pub fn fmt_inner_type<T>(&self, ty: &Type<T>) -> Cow<'static, str>
    where
        T: crate::hir::TyPosition,
    {
        match ty {
            Type::Primitive(primitive_type) => self.fmt_primitive_as_csharp(primitive_type).into(),
            Type::Opaque(opaque_path) => {
                let resolved = opaque_path.resolve(self.tcx);
                Self::fmt_type_name_from_typedef(&crate::hir::TypeDef::Opaque(resolved)).into()
            },
            Type::Struct(struct_type) => {
                let resolved = self.tcx.resolve_type(struct_type.id());
                Self::fmt_type_name_from_typedef(&resolved).into()
            }
            Type::ImplTrait(_) => todo!(),
            Type::Enum(enum_path) => {
                let resolved = enum_path.resolve(&self.tcx);
                Self::fmt_type_name_from_typedef(&crate::hir::TypeDef::Enum(resolved)).into()
            },
            Type::Slice(slice) => {
                let inner_type: crate::hir::Type::<crate::hir::Everywhere> = match slice {
                    crate::hir::Slice::Str(_borrow, crate::hir::StringEncoding::Utf8 | crate::hir::StringEncoding::UnvalidatedUtf8) => {
                        crate::hir::Type::Primitive(crate::hir::PrimitiveType::Byte)
                    },
                    crate::hir::Slice::Str(_borrow, crate::hir::StringEncoding::UnvalidatedUtf16) => {
                        crate::hir::Type::Primitive(crate::hir::PrimitiveType::Char)
                    },
                    crate::hir::Slice::Primitive(_borrow, primitive_type) => {
                        crate::hir::Type::Primitive(*primitive_type)
                    },
                    crate::hir::Slice::Strs(string_encoding) => {
                        // TODO: check that None is correct here
                        crate::hir::Type::Slice(crate::hir::Slice::Str(None, *string_encoding))
                    },
                    _ => todo!(),
                };

                let inner_formatted = self.fmt_inner_type(&inner_type);
                format!("DiplomatRuntime::Slice<{}>", inner_formatted).into()
            },
            Type::Callback(_) => todo!(),
            Type::DiplomatOption(inner_type) => {
                let inner_formatted = self.fmt_inner_type(&inner_type);
                format!("DiplomatRuntime::DiplomatResultVoidError<{}>", inner_formatted).into()
            },
            _ => todo!(),
        }
    }

    pub fn fmt_function_parameter_type(
        &self,
        ty: &Type<crate::hir::InputOnly>,
    ) -> Cow<'static, str> {
        self.fmt_inner_type(ty)
    }

    /// A function parameter is an identifier
    /// See https://learn.microsoft.com/en-us/dotnet/csharp/language-reference/keywords/method-parameters
    pub fn fmt_function_parameter(&self, ident: &crate::hir::IdentBuf) -> String {
        use heck::ToLowerCamelCase;
        ident.as_str().to_lower_camel_case()
    }

    /// What is the natural csharp primitive to fit this primitive type in the FFI
    pub fn fmt_primitive_as_csharp(&self, prim: &PrimitiveType) -> &'static str {
        match prim {
            PrimitiveType::Int(IntType::U8) | PrimitiveType::Byte => "byte",
            PrimitiveType::Int(IntType::U16) => "ushort",
            PrimitiveType::Int(IntType::U32) => "uint",
            PrimitiveType::Int(IntType::U64) => "ulong",
            PrimitiveType::Int(IntType::I8) => "sbyte",
            PrimitiveType::Int(IntType::I16) => "short",
            PrimitiveType::Int(IntType::I32) => "int",
            PrimitiveType::Int(IntType::I64) => "long",
            PrimitiveType::IntSize(IntSizeType::Usize) => "nuint",
            PrimitiveType::IntSize(IntSizeType::Isize) => "nint",
            PrimitiveType::Int128(Int128Type::I128) => "System.Int128",
            PrimitiveType::Int128(Int128Type::U128) => "System.UInt128",
            PrimitiveType::Char => "uint",
            PrimitiveType::Float(FloatType::F32) => "float",
            PrimitiveType::Float(FloatType::F64) => "double",
            PrimitiveType::Bool => "bool",
        }
    }

    pub fn check_identifier(candidate: &str) -> IdentifierCheckResultKind {
        todo!()
    }

    /// These are keywords which can never appear as identifiers
    /// See: https://learn.microsoft.com/en-us/dotnet/csharp/language-reference/keywords/
    const KEYWORDS: &'static [&'static str] = &[
        "abstract",
        "as",
        "base",
        "bool",
        "break",
        "byte",
        "case",
        "catch",
        "char",
        "checked",
        "class",
        "const",
        "continue",
        "decimal",
        "default",
        "delegate",
        "do",
        "double",
        "else",
        "enum",
        "event",
        "explicit",
        "extern",
        "false",
        "finally",
        "fixed",
        "float",
        "for",
        "foreach",
        "goto",
        "if",
        "implicit",
        "in",
        "int",
        "interface",
        "internal",
        "is",
        "lock",
        "long",
        "namespace",
        "new",
        "null",
        "object",
        "operator",
        "out",
        "override",
        "params",
        "private",
        "protected",
        "public",
        "readonly",
        "ref",
        "return",
        "sbyte",
        "sealed",
        "short",
        "sizeof",
        "stackalloc",
        "static",
        "string",
        "struct",
        "switch",
        "this",
        "throw",
        "true",
        "try",
        "typeof",
        "uint",
        "ulong",
        "unchecked",
        "unsafe",
        "ushort",
        "using",
        "virtual",
        "void",
        "volatile",
        "while"
    ];
}


enum IdentifierViolationKind {
    /// Allowed character violation
    /// The allowed characters are [A-Z], [a-z], [0-9] & _
    ForbiddenCharacter,
    /// The starting character cannot be a digit
    StartingCharacterIsDigit,
    /// The identifier contains whitespace
    HasWhitespace,
    /// The maximum length of an identifier in C# is 512 characters
    TooLong,
    /// The identifier is a keyword
    IsKeyword,
    /// Double underscores are reserved
    ForbiddenDoubleUnderscore
}

enum IdentifierCheckResultKind {
    Valid,
    InvalidCharacters(usize, usize),
}
