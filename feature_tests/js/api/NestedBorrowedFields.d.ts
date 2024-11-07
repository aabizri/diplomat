// generated by diplomat-tool
import type { Bar } from "./Bar"
import type { BorrowedFields } from "./BorrowedFields"
import type { BorrowedFieldsWithBounds } from "./BorrowedFieldsWithBounds"
import type { Foo } from "./Foo"
import type { pointer, codepoint } from "./diplomat-runtime.d.ts";

type NestedBorrowedFields_Obj = {
    fields: BorrowedFields;
    bounds: BorrowedFieldsWithBounds;
    bounds2: BorrowedFieldsWithBounds;
};

export class NestedBorrowedFields {

    get fields() : BorrowedFields;
    set fields(value: BorrowedFields); 

    get bounds() : BorrowedFieldsWithBounds;
    set bounds(value: BorrowedFieldsWithBounds); 

    get bounds2() : BorrowedFieldsWithBounds;
    set bounds2(value: BorrowedFieldsWithBounds); 
    constructor(structObj : NestedBorrowedFields_Obj);

    static fromBarAndFooAndStrings(bar: Bar, foo: Foo, dstr16X: string, dstr16Z: string, utf8StrY: string, utf8StrZ: string): NestedBorrowedFields;
}