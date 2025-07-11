module lucy::util;

import lucy::node;
import std::core::string, std::core::mem, std::os, std::io;
import llvm;

const String LOWERCASE   = "abcdefghijklmnopqrstuvwxyz";
const String UPPERCASE   = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";

macro bool in(arr, el)
{
    foreach (a : arr)
    {
        if (a == el) return true;
    }
    return false;
}

macro void array_insert(arr, element)
{
    var $Type = $typeof(element);
    $Type[] tmp = mem::new_array($Type, (*arr).len + 1);
    
    // avoid mem::copy for 0 sized array
    for (int i = 0; i < (*arr).len; i++)
    {
        tmp[i] = (*arr)[i];
    }

    tmp[(*arr).len] = element;

    *arr = tmp;
}

macro void panicf(String fmt, args..., String file, int line) @noreturn
{
    panic(string::tformat(fmt, args), file, line);
}

<*
 @require message.len <= 73 : "message cannot be longer than 73 characters"
*>
fn void panic(String message, String file, int line) @noreturn
{
    io::eprint  (Ansi.YELLOW);
    io::eprintn ("╭──────────────────────────────────────────────────────────────────────────────────╮");
    io::eprintn ("│ ⚠️ Feature not implemented yet                                                   │");
    io::eprintfn("│ Issue: %-*s │", 73, message);
    io::eprintfn("│ In file: %-*s │", 71, string::tformat("%s (%d)", file, line));
    io::eprintn ("│                                                                                  │");
    io::eprintn ("│ Please create an issue on github at https://github.com/lucy-language/lucy/issues │");
    io::eprintn ("│ and include your compiler version you can get by running `lucy --version`        │");
    io::eprintn ("╰──────────────────────────────────────────────────────────────────────────────────╯");
    io::eprint (Ansi.RESET);
    os::exit(1);
}

fn String join_to_string(String[] arr, String separator)
{
    DString result;
    result.init(mem);
    defer result.free();

    bool first = true;
    foreach (x : arr)
    {
        if (!first) result.append_chars(separator);
        if (first) first = false;

        result.append_chars(x);
    }

    return result.copy_str(mem);
}

fn String[] all_ends(String[] arr, String el)
{
    String[] ends;
    foreach (a : arr)
    {
        if (a.ends_with(el))
        {
            array_insert(&ends, a);
        }
    }

    return ends;
}

fn ASTNode make_null()
{
    return { NULL, { .null_node = { "null" } }, {}, 0, {} };
}
