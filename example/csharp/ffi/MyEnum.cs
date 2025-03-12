using System.Runtime.InteropServices;

namespace SomeLib.FFI;

internal static unsafe partial class Library
{
    [DllImport(
        __DllName,
        EntryPoint = "my_enum_new",
        CallingConvention = CallingConvention.Cdecl,
        ExactSpelling = true
    )]
    public static extern MyEnum MyEnumNew();
}

// If we have repr(u8), then : byte
// If we have repr(u16), then : ushort
// If we have repr(u32), then : uint
public enum MyEnum {
    A = -2,
    B = -1,
    C = 0,
    D = 1,
    E = 2,
    F = 3
}
