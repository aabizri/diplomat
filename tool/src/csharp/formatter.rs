// Reference: https://github.com/Cysharp/csbindgen/

use std::borrow::Cow;

use diplomat_core::hir::{
    Docs, DocsUrlGenerator, FloatType, Ident, Int128Type, IntSizeType, IntType, PrimitiveType,
    ReturnType, StructField, StructPathLike, TyPosition, Type, TypeContext, TypeId,
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

    pub fn fmt_type_name(&self, id: TypeId) -> String {
        let ty = self.tcx.resolve_type(id);

        let base = ty.name().as_str();
        let renamed = ty.attrs().rename.apply(base.into());

        // C# uses PascalCase for types (except primitives and the like)
        use heck::ToPascalCase;
        let cased = renamed.to_pascal_case();

        cased
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
                        Some(t) => self.fmt_function_type(t),
                        None => unreachable!(),
                    }
                }
            }
            ReturnType::Fallible(success_type, error_type) => todo!(),
            ReturnType::Nullable(success_type) => todo!("implement support for {:?}", success_type),
        }
    }

    pub fn fmt_function_type<T>(&self, ty: &Type<T>) -> Cow<'static, str>
    where
        T: crate::hir::TyPosition,
    {
        match ty {
            Type::Primitive(primitive_type) => self.fmt_primitive_as_csharp(primitive_type).into(),
            Type::Opaque(opaque_path) => "MyOpaque".into(),
            Type::Struct(struct_type) => "MYSTRUCT".into(),
            Type::ImplTrait(_) => todo!(),
            Type::Enum(enum_path) => todo!(),
            Type::Slice(slice) => "MySlice".into(),
            Type::Callback(_) => todo!(),
            Type::DiplomatOption(_) => todo!(),
            _ => todo!(),
        }
    }

    pub fn fmt_function_parameter_type(
        &self,
        ty: &Type<crate::hir::InputOnly>,
    ) -> Cow<'static, str> {
        self.fmt_function_type(ty)
    }

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
}
