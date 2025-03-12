using System.Runtime.InteropServices;

namespace SomeLib;

public struct MyStruct {
    private FFI.MyStruct ffi;

    internal MyStruct(FFI.MyStruct ffi) {
        this.ffi = ffi;
    }

    public MyStruct(): this(FFI.Library.MyStructNew()) {}

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

    // With stringifier attribute
    public override string ToString() {
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

    // Demonstration of a method returning a boxed value
    public static MyStruct StaticNotConstructor() {
        FFI.MyStruct ffi = FFI.Library.MyStructStaticNotConstructor();
        return new MyStruct(ffi);
    }

    // Demonstration of a getter
    public byte Something {
        get => FFI.Library.MyStructGetSomething(this.ffi).Unwrap();
    }

    // For each field, we generate a getter/setter pair
    // Converting if needed
    public byte A {
        get => ffi.a;
        set => ffi.a = value;
    }
    public short B {
        get => ffi.b;
        set => ffi.b = value;
    }
    public sbyte C {
        get => ffi.c;
        set => ffi.c = value;
    }
    public ushort D {
        get => ffi.d;
        set => ffi.d = value;
    }
    public bool MyBool {
        get => Convert.ToBoolean(ffi.myBool);
        set => ffi.myBool = Convert.ToByte(value);
    }





}
