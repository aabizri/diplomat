use diplomat_core::hir::{BackendAttrSupport, OpaqueDef, TypeContext, TypeId};
mod formatter;
mod method;

fn gen_opaque_def(ctx: &TypeContext, type_id: TypeId, opaque_path: &OpaqueDef) -> String {
    "We'll get to it".into()
}

pub enum ImportMode {
    DLLImport,
    LibraryImport,
}

pub(crate) fn attr_support() -> BackendAttrSupport {
    let mut a = BackendAttrSupport::default();

    a.namespacing = true;
    a.memory_sharing = false;
    a.non_exhaustive_structs = false;
    a.method_overloading = false;
    a.utf8_strings = false;
    a.utf16_strings = true;
    a.static_slices = false;

    a.constructors = true;
    a.named_constructors = true;
    a.fallible_constructors = true;
    a.accessors = true;
    a.stringifiers = true;
    a.comparators = true;
    a.iterators = true;
    a.iterables = true;
    a.indexing = true;
    a.option = true;
    a.callbacks = false;
    a.traits = false;
    a.traits_are_send = false;
    a.traits_are_sync = false;

    a
}

const DISALLOWED_CORE_TYPES: &[&str] = &[];

pub(crate) fn run<'cx>(
    tcx: &'cx TypeContext,
    docs_url_gen: &'cx diplomat_core::hir::DocsUrlGenerator,
) -> (crate::FileMap, crate::ErrorStore<'cx, String>) {
    let files = crate::FileMap::default();
    //let errors = crate::ErrorStore::default();

    let formatter = formatter::CSharpFormatter::new(tcx, docs_url_gen);

    for (id, ty) in tcx.all_types() {
        if ty.attrs().disable {
            continue;
        }

        let type_name = formatter.fmt_type_name(id);
        let file_name = format!("{type_name}.cs");
        println!("type_name: {type_name} in file {file_name}");
        // Do something

        //errors.set_context_ty(ty.name().as_str().into());

        match ty {
            crate::hir::TypeDef::Enum(e) => (), /* self.gen_enum(e, id, &name)*/,
            crate::hir::TypeDef::Opaque(o) => (), /*self.gen_opaque_def(o, id, &name)*/,
            crate::hir::TypeDef::Struct(s) => {}
            crate::hir::TypeDef::OutStruct(s) => (), /*self.gen_struct_def(s, id, true, &name, false)*/,
            _ => unreachable!("unknown AST/HIR variant"),
        };

        ty.methods()
            .iter()
            .map(|me| method::Method {
                inner: me,
                formatter: &formatter,
            })
            .for_each(|me| println!("{}", me.generate_function_declaration()));
    }

    unimplemented!()
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
