use askama::DynTemplate;

pub struct Method<'a> {
    pub inner: &'a crate::hir::Method,
    pub formatter: &'a super::formatter::CSharpFormatter<'a>,
}

impl<'a> Method<'a> {
    pub fn cs_type(&self) -> std::borrow::Cow<'static, str> {
        self.formatter.fmt_function_return_type(&self.inner.output)
    }

    pub fn cs_name(&self) -> String {
        self.formatter.fmt_function_name(&self.inner.name)
    }
}

struct MethodParameter<'a> {
    pub formatter: &'a super::formatter::CSharpFormatter<'a>,
    pub inner: &'a crate::hir::Param,
}

impl<'a> MethodParameter<'a> {
    pub fn cs_type(&self) -> std::borrow::Cow<'static, str> {
        self.formatter.fmt_function_parameter_type(&self.inner.ty)
    }

    pub fn cs_name(&self) -> String {
        self.formatter.fmt_function_parameter(&self.inner.name)
    }
}

impl<'a> Method<'a> {
    pub fn generate_function_declaration<'fmt>(&self) -> String {
        #[derive(askama::Template)]
        #[template(
            path = "csharp/ffi_function_declaration.cs.jinja",
            escape = "none",
            print = "all"
        )]
        struct Template<'b> {
            method: &'b Method<'b>,
        }

        let template = Template { method: self };
        template.dyn_render().unwrap()
    }

    pub fn params<'fmt>(&'fmt self) -> impl Iterator<Item = MethodParameter<'fmt>> {
        self.inner
            .params
            .iter()
            .map(|method_param| MethodParameter {
                inner: method_param,
                formatter: self.formatter,
            })
    }

    pub fn docs(&self) -> Option<&crate::hir::Docs> {
        self.docs()
    }
}
