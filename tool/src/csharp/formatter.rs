// Reference: https://github.com/Cysharp/csbindgen/

use std::borrow::Cow;

use diplomat_core::hir::{Docs, DocsUrlGenerator, FloatType, Ident, Int128Type, IntSizeType, IntType, PrimitiveType, StructField, TyPosition, Type, TypeContext, TypeId};

pub(super) struct CSharpFormatter<'tcx> {
    tcx: &'tcx TypeContext,
    docs_url_gen: &'tcx DocsUrlGenerator
}

impl<'tcx> CSharpFormatter<'tcx> {
    pub fn new(
        tcx: &'tcx TypeContext,
        docs_url_gen: &'tcx DocsUrlGenerator
    ) -> Self {
        Self {
            tcx,
            docs_url_gen
        }
    }

    /// What is the natural csharp primitive to fit this primitive type in the FFI
    pub fn fmt_primitive_as_csharp(&self, prim: PrimitiveType) -> std::borrow::Cow<'static, str> {
        match prim {
            PrimitiveType::Int(IntType::U8) | PrimitiveType::Byte => "byte".into(),
            PrimitiveType::Int(IntType::U16) => "ushort".into(),
            PrimitiveType::Int(IntType::U32) => "uint".into(),
            PrimitiveType::Int(IntType::U64) => "ulong".into(),
            PrimitiveType::Int(IntType::I8) => "sbyte".into(),
            PrimitiveType::Int(IntType::I16) => "short".into(),
            PrimitiveType::Int(IntType::I32) => "int".into(),
            PrimitiveType::Int(IntType::I64) => "long".into(),
            PrimitiveType::IntSize(IntSizeType::Usize) => "nuint".into(),
            PrimitiveType::IntSize(IntSizeType::Isize) => "nint".into(),
            PrimitiveType::Int128(Int128Type::I128) => "System.Int128".into(),
            PrimitiveType::Int128(Int128Type::U128) => "System.UInt128".into(),
            PrimitiveType::Char => "uint".into(),
            PrimitiveType::Float(FloatType::F32) => "float".into(),
            PrimitiveType::Float(FloatType::F64) => "double".into(),
            PrimitiveType::Bool => "bool".into()
        }
    }

    pub fn fmt_lowered_field_attribute<'a, W: std::fmt::Write, P: TyPosition>(&'a self, mut fmt: W, field: &'a StructField<P>) -> std::fmt::Result  {
        match &field.ty {
            Type::Primitive(primitive_type) => match primitive_type {
                PrimitiveType::Bool => write!(fmt, "[MarshalAs(UnmanagedType.U1)]")?,
                _ => ()
            },
            _ => (),
        };

        Ok(())
    }

    pub fn fmt_docs<'a, W: std::fmt::Write>(&'a self, mut fmt: W, docs: &Docs) -> std::fmt::Result {
        let str = docs.as_str();
        
        // We'll take the first non-empty line as being the summary
        let mut lines = str.lines();
        
        let summary = 
        {
            let summary = lines.find(|l| !l.trim().is_empty());
            if summary.is_none() {
                return Ok(());
            }
            summary.unwrap()
        };
        
        write!(fmt, r"
        <summary>
        {summary}
        </summary>\n")?;

        // Skip any remaining empty lines
        let remark_lines = lines.skip_while(|l| l.trim().is_empty());
        let mut started_remarks = false;
        for line in remark_lines {
            if !started_remarks {
                write!(fmt, "<remarks>\n")?;
                started_remarks = true;
            }
            write!(fmt, "{}\n", line)?;
        }
        if started_remarks {
            write!(fmt, "</remarks>\n")?;
        }

        Ok(())
    }

    /// Formats the field of a struct
    pub fn fmt_field_decl<'a, W: std::fmt::Write, P: TyPosition>(&'a self, mut fmt: W, field: &'a StructField<P>) -> Cow<'tcx, str> {
        self.fmt_docs(&mut fmt, &field.docs).unwrap();
        self.fmt_lowered_field_attribute(&mut fmt, field).unwrap();

    }

    pub fn fmt_primitive_as_struct_member(&self,prim: PrimitiveType) -> Option<&'static str> {
        match prim {
            PrimitiveType::Bool => Some("[MarshalAs(UnmanagedType.U1)]"),
            _ => None
        }
    }

    // TODO: Right type
    pub fn fmt_dllimport<W: std::fmt::Write>(&self, mut fmt: W, ident: &Ident) -> std::fmt::Result {
        write!(fmt, r#"[DllImport(__DllName, EntryPoint = "{ident}", CallingConvention = CallingConvention.Cdecl, ExactSpelling = true)]"#)
    }
}