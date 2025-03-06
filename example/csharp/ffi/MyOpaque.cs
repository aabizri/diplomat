using System.Runtime.InteropServices;

namespace SomeLib.FFI;

internal static unsafe partial class Library
{
    [DllImport(
        __DllName,
        EntryPoint = "my_opaque_new",
        CallingConvention = CallingConvention.Cdecl,
        ExactSpelling = true
    )]
    public static extern void* MyOpaqueNew();

    [DllImport(
        __DllName,
        EntryPoint = "my_opaque_format",
        CallingConvention = CallingConvention.Cdecl,
        ExactSpelling = true
    )]
    public static extern void MyOpaqueFormat(void* self, DiplomatRuntime.DiplomatWrite* dw);

    [DllImport(
        __DllName,
        EntryPoint = "my_opaque_destroy",
        CallingConvention = CallingConvention.Cdecl,
        ExactSpelling = true
    )]
    public static extern void MyOpaqueDestroy(void* self);
}
