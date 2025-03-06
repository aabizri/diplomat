use diplomat_core::hir::{OpaqueDef, TypeContext, TypeId};
mod formatter;

fn gen_opaque_def(ctx: &TypeContext, type_id: TypeId, opaque_path: &OpaqueDef) -> String {
    "We'll get to it".into()
}

pub enum ImportMode {
    DLLImport,
    LibraryImport,
}

pub(crate) fn run<'cx>(
    tcx: &'cx TypeContext
) -> (crate::FileMap, crate::ErrorStore<'cx, String>) {


    todo!()
}

#[cfg(test)]
mod test {
    use diplomat_core::{
        ast::{self},
        hir::{self, TypeDef},
    };
    use quote::quote;

    #[test]
    fn test_opaque_gen() {
        let tokens = quote! {
            #[diplomat::bridge]
            mod ffi {

                #[diplomat::opaque]
                struct OpaqueStruct;

            }
        };
        let file = syn::parse2::<syn::File>(tokens).expect("failed to parse item ");

        let attr_validator = hir::BasicAttributeValidator::new("my_backend_test");

        let context = match hir::TypeContext::from_syn(&file, attr_validator) {
            Ok(context) => context,
            Err(e) => {
                for (_cx, err) in e {
                    eprintln!("Lowering error: {}", err);
                }
                panic!("Failed to create context")
            }
        };

        let (type_id, opaque_def) = match context
            .all_types()
            .next()
            .expect("Failed to generate first opaque def")
        {
            (type_id, TypeDef::Opaque(opaque_def)) => (type_id, opaque_def),
            _ => panic!("Failed to find opaque type from AST"),
        };

        let generated = super::gen_opaque_def(&context, type_id, opaque_def);

        insta::assert_snapshot!(generated)
    }
}