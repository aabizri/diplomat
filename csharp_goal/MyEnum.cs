using System.Runtime.InteropServices;

namespace SomeLib;

public struct MyEnum {
    public FFI.MyEnum Value;

    public MyEnum() {
        this.Value = FFI.Library.MyEnumNew();
    }


}
