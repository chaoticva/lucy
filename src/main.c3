module lucy;

import std;
import args;
import json;
import llvm;
import libc;

fn int main(String[] args)
{
    Option[]? options = args::parse(
        args:    args,
        arg_sep: " ",
        options: {
            {
                .short_name  = "ll",
                .long_name   = "lexer",
                .description = "stops after the lexing stage"
            },
            {
                .short_name  = "p",
                .long_name   = "parser",
                .description = "stops after the parsing stage"
            },
            {
                .short_name  = "a",
                .long_name   = "analyser",
                .description = "stops after the analysing stage"
            },
            {
                .short_name        = "t",
                .long_name         = "tree",
                .description       = "outputs the ast mor the main module",
                .valid_values      = { "file", "stdout" },
                .is_value_required = true
            },
            {
                .long_name   = "version",
                .description = "prints the version info to stdout",
                .is_value_required   = false
            },
            {
                .short_name  = "e",
                .long_name   = "emit-llvm",
                .description = "prints the module to a llvm IR file"
            },
            {
                .short_name        = "c",
                .long_name         = "compile",
                .description       = "compile a file",
                .example_value     = "FILE",
                .is_value_required = true
            },
            {
                .short_name        = "l",
                .long_name         = "link",
                .description       = "link with this library",
                .is_value_required = true
            },
            {
                .long_name   = "no-stdlib",
                .description = "compiles without including the stdlib"
            },
            {
                .short_name  = "v",
                .long_name   = "verbose",
                .description = "Output additional compiler info"
            }
        }
    );

    if (catch err = options)
    {
        io::eprintn(err);
        return 1;
    }

    if (args::has_arg_long(options, "version")!!)
    {
        io::printfn("%-*s%s", 30, "Compiler Version:", VERSION);
        $if $feature(GIT_FOUND):
            io::printfn("%-*s%s", 30, "Git hash:", GIT_HASH);
        $endif
        io::printfn("%-*s%s", 30, "Backends:", BACKENDS);
        io::printfn("%-*s%s", 30, "LLVM Default Target:", (ZString)llvm::get_default_target_triple());
        return 0;
    }

    if (args::has_arg_long(options, "compile")!!)
    {
        String? compile_option = args::arg_value(options, "compile");
        if (catch compile_option)
        {
            io::eprintn("expected value for option `compile`");
            return 1;
        }

        String path    = compile_option.to_absolute_path(mem).str_view()!!;
        String content = (String)file::load(mem, path)!!;

        lucy::lexer::Lexer lexer = lexer::new(content);

        if (args::has_arg_long(options, "lexer")!!)
        {
            foreach(token : lexer.tokenize())
            {
                io::printn(token.type);
            }
            return 0;
        }
        
        Parser   parser = parser::new(lexer, path);
        ASTNode* ast    = parser.parse();

        if (args::has_arg_long(options, "tree")!!)
        {
            String? value = args::arg_value(options, "tree");
            if (catch value)
            {
                io::eprintn("expected value for option `ast`");
                return 1;
            }

            switch (value)
            {
                case "file":   file::save("ast.json", json::to_json(*ast, mem))!!;
                case "stdout": io::printn(json::to_json(*ast, mem)!!);
            }
        }

        if (args::has_arg_long(options, "parser")!!) return 0;
        
        String[] linked_module_paths;
        if (!args::has_arg_long(options, "no-stdlib")!!) add_stdlib(&linked_module_paths);

        TypeTable* type_table = malloc(TypeTable.sizeof);
        (*type_table).init();
        Scope* scope = scope::new();

        Sema sema = sema::new(path, scope, type_table, linked_module_paths, ast);
        sema.analyse();

        if (args::has_arg_long(options, "analyser")!!) return 0;

        /*
        // Need to reinstantiate because json fucks it up somehow
        // TODO: fix
        parser = parser::new(lexer, path);
        Compiler compiler = compiler::new(path, parser.parse(), type_table);
        compiler.compile(links);

        linker::link(compiler.mod, compiler.module_name, compiler.linker_options, !args::has_arg_long(options, "no-stdlib")!!);
        
        if (args::has_arg_long(options, "emit-llvm")!!)
        {
            llvm::print_module_to_file(compiler.mod, string::format(mem, "%s.ll", compiler.module_name), null);
        }
        */
    } else
    {
        String[] invalid_options = { "lexer", "parser", "analyser", "tree", "emit-llvm", "link", "no-stdlib" };
        foreach (option : invalid_options)
        {
            if (args::has_arg_long(options, option)!!)
            {
                io::eprintfn("option `%s` can only be used together with `compile`", option);
                return 1;
            }
        }
    }

    return 0;
}

fn void add_stdlib(String[]* linked_module_paths)
{
    const BUF_SIZE = 1024;
    char[BUF_SIZE] buf;
    libc::readlink("/proc/self/exe", &buf, BUF_SIZE);

    Path? exe_path = ((ZString)&buf).str_view().to_absolute_path(mem);
    if (catch exe_path)
    {
        io::eprintn("Unable to make out executable path");
        return;
    }

    Path? stdlib_path = exe_path.parent().append(mem, "stdlib");
    if (catch stdlib_path)
    {
        io::eprintn("Unable to make out stdlib path");
        return;
    }

    (void)path::traverse(stdlib_path, &path_callback, linked_module_paths);
}

fn bool? path_callback(Path path, bool is_dir, any data)
{
    String[]* linked_module_paths = (String[]*)data;

    if (is_dir) return false;
    if (path.has_extension("lc"))
    {
        (void)util::array_insert(linked_module_paths, path.absolute(mem).str_view());
    }

    return false;
}
