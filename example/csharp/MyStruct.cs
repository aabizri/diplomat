using System.Runtime.InteropServices;

namespace SomeLib;

struct MyStruct {
    private FFI.MyStruct ffi;

    public MyStruct() {
        this.ffi = FFI.Library.MyStructNew();
    }

    // NOTE: The direct translation of the FFI
    public string Format() {
        DiplomatRuntime.DiplomatWrite dwStruct = DiplomatRuntime.DiplomatWriteExtensions.WithCapacity(256);
        try {
            unsafe {
                // We give by value as the struct is not opaque
                FFI.Library.MyStructFormat(ffi, &dwStruct);
            }

            return DiplomatRuntime.DiplomatWriteExtensions.ToString(dwStruct);
        } finally {
            DiplomatRuntime.DiplomatWriteExtensions.Destroy(dwStruct);
        }
    }
}
