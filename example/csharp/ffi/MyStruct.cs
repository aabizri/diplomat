using System.Runtime.InteropServices;

namespace SomeLib.FFI;

internal static unsafe partial class Library
{
    [DllImport(
        __DllName,
        EntryPoint = "my_struct_new",
        CallingConvention = CallingConvention.Cdecl,
        ExactSpelling = true
    )]
    public static extern MyStruct MyStructNew();

    [DllImport(
        __DllName,
        EntryPoint = "my_struct_format",
        CallingConvention = CallingConvention.Cdecl,
        ExactSpelling = true
    )]
    public static extern void MyStructFormat(MyStruct self, DiplomatRuntime.DiplomatWrite* dw);
}

[StructLayout(LayoutKind.Sequential)]
internal unsafe struct MyStruct {
    byte a;
    short b;
    sbyte c;
    ushort d;
}
