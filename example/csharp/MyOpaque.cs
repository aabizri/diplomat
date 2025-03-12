using System.Runtime.InteropServices;

namespace SomeLib;

public class MyOpaque {
    unsafe private void* ffi;

    public MyOpaque() {
        unsafe {
            this.ffi = FFI.Library.MyOpaqueNew();
        }
    }

    ~MyOpaque() {
        unsafe {
            FFI.Library.MyOpaqueDestroy(this.ffi);
        }
    }

    // NOTE: The direct translation of the FFI
    public string Format() {
        DiplomatRuntime.DiplomatWrite dwStruct = DiplomatRuntime.DiplomatWriteExtensions.WithCapacity(256);
        try {
            unsafe {
                // We give by value as it's opaque, but we have the pointer
                FFI.Library.MyOpaqueFormat(ffi, &dwStruct);
            }

            return DiplomatRuntime.DiplomatWriteExtensions.ToString(dwStruct);
        } finally {
            DiplomatRuntime.DiplomatWriteExtensions.Destroy(dwStruct);
        }
    }
}