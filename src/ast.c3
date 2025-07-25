module lucy;

import json;
import std::io;

fn void? ASTNode.to_json(&self, DString* dest, int indent, int indent_level)
{
	switch (self.node_type) {
        case INIT_VALUE: serialize::add_json(self.node.init_value_node, dest, indent, indent_level)!;
		case PARAMETER:  serialize::add_json(self.node.parameter_node, dest, indent, indent_level)!;
		case REASSIGN:   serialize::add_json(self.node.reassign_node, dest, indent, indent_level)!;
        case ACCESS:     serialize::add_json(self.node.access_node, dest, indent, indent_level)!;
		case STRUCT:     serialize::add_json(self.node.struct_node, dest, indent, indent_level)!;
		case RETURN:     serialize::add_json(self.node.return_node, dest, indent, indent_level)!;
		case DOUBLE:     serialize::add_json(self.node.double_node, dest, indent, indent_level)!;
		case GLOBAL:     serialize::add_json(self.node.global_node, dest, indent, indent_level)!;
        case SWITCH:     serialize::add_json(self.node.switch_node, dest, indent, indent_level)!;
		case FLOAT:      serialize::add_json(self.node.float_node, dest, indent, indent_level)!;
		case CONST:      serialize::add_json(self.node.const_node, dest, indent, indent_level)!;
		case IDENT:      serialize::add_json(self.node.ident_node, dest, indent, indent_level)!;
		case FIELD:      serialize::add_json(self.node.field_node, dest, indent, indent_level)!;
		case MACRO:      serialize::add_json(self.node.macro_node, dest, indent, indent_level)!;
		case UNARY:      serialize::add_json(self.node.unary_node, dest, indent, indent_level)!;
		case WHILE:      serialize::add_json(self.node.while_node, dest, indent, indent_level)!;
		case TUPLE:      serialize::add_json(self.node.tuple_node, dest, indent, indent_level)!;
		case FILE:       serialize::add_json(self.node.file_node, dest, indent, indent_level)!;
		case BOOL:       serialize::add_json(self.node.bool_node, dest, indent, indent_level)!;
		case LINK:       serialize::add_json(self.node.link_node, dest, indent, indent_level)!;
		case CALL:       serialize::add_json(self.node.call_node, dest, indent, indent_level)!;
        case CHAR:       serialize::add_json(self.node.char_node, dest, indent, indent_level)!;
        case INIT:       serialize::add_json(self.node.init_node, dest, indent, indent_level)!;
        case CASE:       serialize::add_json(self.node.case_node, dest, indent, indent_level)!;
        case PATH:       serialize::add_json(self.node.path_node, dest, indent, indent_level)!;
        case NULL:       serialize::add_json(self.node.null_node, dest, indent, indent_level)!;
		case USE:        serialize::add_json(self.node.use_node, dest, indent, indent_level)!;
		case DEF:        serialize::add_json(self.node.def_node, dest, indent, indent_level)!;
		case INT:        serialize::add_json(self.node.int_node, dest, indent, indent_level)!;
		case STR:        serialize::add_json(self.node.str_node, dest, indent, indent_level)!;
		case BIN:        serialize::add_json(self.node.bin_node, dest, indent, indent_level)!;
		case EXT:        serialize::add_json(self.node.ext_node, dest, indent, indent_level)!;
		case VAR:        serialize::add_json(self.node.var_node, dest, indent, indent_level)!;
		case INC:        serialize::add_json(self.node.inc_node, dest, indent, indent_level)!;
		case FOR:        serialize::add_json(self.node.for_node, dest, indent, indent_level)!;
		case PKG:        serialize::add_json(self.node.pkg_node, dest, indent, indent_level)!;
		case IF:         serialize::add_json(self.node.if_node, dest, indent, indent_level)!;
	}
}

struct ParameterJson { NodeType node_type; bool is_vararg; ASTNode type; ASTNode name; }
struct ReassignJson  { NodeType node_type; ASTNode name; ASTNode value; }
struct ReturnJson    { NodeType node_type; ASTNode[] values; }
struct DoubleJson    { NodeType node_type; String value; }
struct GlobalJson    { NodeType node_type; ASTNode node; }
struct FloatJson     { NodeType node_type; String value; }
struct ConstJson     { NodeType node_type; ASTNode type; ASTNode name; ASTNode value; }
struct IdentJson     { NodeType node_type; String name; }
struct FileJson      { NodeType node_type; ASTNode[] linker_options; ASTNode pkg; ASTNode[] statements; }
struct BoolJson      { NodeType node_type; String value; }
struct CallJson      { NodeType node_type; ASTNode name; ASTNode[] arguments; }
struct CharJson      { NodeType node_type; String value; }
struct UseJson       { NodeType node_type; ASTNode path; }
struct DefJson       { NodeType node_type; ASTNode type; ASTNode name; ASTNode[] parameters; ASTNode[] children; }
struct IntJson       { NodeType node_type; String value; }
struct StrJson       { NodeType node_type; String value; }
struct BinJson       { NodeType node_type; String operator; ASTNode left; ASTNode right; }
struct ExtJson       { NodeType node_type; ASTNode type; ASTNode name; ASTNode[] parameters; ASTNode aka; }
struct VarJson       { NodeType node_type; ASTNode type; ASTNode[] names; ASTNode value; }
struct VarJson2      { NodeType node_type; String[] types; String[] names; String value; }
struct IfJson        { NodeType node_type; ASTNode condition; ASTNode[] children; ASTNode else_if; ASTNode[] else_children; }
struct FieldJson     { NodeType node_type; ASTNode type; ASTNode name; }
struct StructJson    { NodeType node_type; ASTNode name; ASTNode[] fields; }
struct InitJson      { NodeType node_type; ASTNode[] values; }
struct InitValueJson { NodeType node_type; ASTNode name; ASTNode value; }
struct AccessJson    { NodeType node_type; ASTNode expr; ASTNode next; }
struct MacroJson     { NodeType node_type; ASTNode type; ASTNode name; ASTNode[] parameters; ASTNode[] children; }
struct UnaryJson     { NodeType node_type; String operator; ASTNode expr; }
struct WhileJson     { NodeType node_type; ASTNode condition; ASTNode[] children; }
struct SwitchJson    { NodeType node_type; ASTNode expression; ASTNode[] cases; }
struct CaseJson      { NodeType node_type; ASTNode condition; ASTNode[] children; }
struct IncJson       { NodeType node_type; ASTNode identifier; String operator; }
struct ForJson       { NodeType node_type; ASTNode statement; ASTNode condition; ASTNode expression; ASTNode[] children; }
struct PkgJson       { NodeType node_type; ASTNode path; }
struct PathJson      { NodeType node_type; ASTNode[] segments; }
struct TupleJson     { NodeType node_type; ASTNode[] values; }
struct NullJson      { NodeType node_type; }
struct LinkJson      { NodeType node_type; ASTNode name; }

fn void? ParameterNode.to_json(&self, DString* dest, int indent, int indent_level) => serialize::add_json((ParameterJson){ PARAMETER, self.is_vararg, *self.type, *self.name }, dest, indent, indent_level)!;
fn void? ReassignNode .to_json(&self, DString* dest, int indent, int indent_level) => serialize::add_json((ReassignJson){ REASSIGN, *self.name, *self.value }, dest, indent, indent_level)!;
fn void? DoubleNode   .to_json(&self, DString* dest, int indent, int indent_level) => serialize::add_json((DoubleJson){ DOUBLE, self.value }, dest, indent, indent_level)!;
fn void? GlobalNode   .to_json(&self, DString* dest, int indent, int indent_level) => serialize::add_json((GlobalJson){ GLOBAL, *self.node }, dest, indent, indent_level)!;
fn void? FloatNode    .to_json(&self, DString* dest, int indent, int indent_level) => serialize::add_json((FloatJson){ FLOAT, self.value }, dest, indent, indent_level)!;
fn void? ConstNode    .to_json(&self, DString* dest, int indent, int indent_level) => serialize::add_json((ConstJson){ CONST, *self.type, *self.name, *self.value}, dest, indent, indent_level)!;
fn void? IdentNode    .to_json(&self, DString* dest, int indent, int indent_level) => serialize::add_json((IdentJson){ IDENT, self.name }, dest, indent, indent_level)!;
fn void? FileNode     .to_json(&self, DString* dest, int indent, int indent_level) => serialize::add_json((FileJson){ FILE, self.linker_options, *self.pkg, ref_arr(self.statements) }, dest, indent, indent_level)!;
fn void? BoolNode     .to_json(&self, DString* dest, int indent, int indent_level) => serialize::add_json((BoolJson){ BOOL, self.value }, dest, indent, indent_level)!;
fn void? CallNode     .to_json(&self, DString* dest, int indent, int indent_level) => serialize::add_json((CallJson){ CALL, *self.name, ref_arr(self.arguments) }, dest, indent, indent_level)!;
fn void? CharNode     .to_json(&self, DString* dest, int indent, int indent_level) => serialize::add_json((CharJson){ CHAR, self.value }, dest, indent, indent_level)!;
fn void? UseNode      .to_json(&self, DString* dest, int indent, int indent_level) => serialize::add_json((UseJson){ USE, *self.path }, dest, indent, indent_level)!;
fn void? DefNode      .to_json(&self, DString* dest, int indent, int indent_level) => serialize::add_json((DefJson){ DEF, *self.type, *self.name, ref_arr(self.parameters), ref_arr(self.children) }, dest, indent, indent_level)!;
fn void? IntNode      .to_json(&self, DString* dest, int indent, int indent_level) => serialize::add_json((IntJson){ INT, self.value }, dest, indent, indent_level)!;
fn void? StrNode      .to_json(&self, DString* dest, int indent, int indent_level) => serialize::add_json((StrJson){ STR, self.value }, dest, indent, indent_level)!;
fn void? BinNode      .to_json(&self, DString* dest, int indent, int indent_level) => serialize::add_json((BinJson){ BIN, self.operator, *self.left, *self.right }, dest, indent, indent_level)!;
fn void? ExtNode      .to_json(&self, DString* dest, int indent, int indent_level) => serialize::add_json((ExtJson){ EXT, *self.type, *self.name, ref_arr(self.parameters), *self.aka }, dest, indent, indent_level)!;
fn void? VarNode      .to_json(&self, DString* dest, int indent, int indent_level) => serialize::add_json((VarJson){ VAR, *self.type, ref_arr(self.names), *self.value }, dest, indent, indent_level)!;
fn void? IfNode       .to_json(&self, DString* dest, int indent, int indent_level) => serialize::add_json((IfJson){ IF, *self.condition, ref_arr(self.children), *self.else_if, ref_arr(self.else_children) }, dest, indent, indent_level)!;
fn void? FieldNode    .to_json(&self, DString* dest, int indent, int indent_level) => serialize::add_json((FieldJson){ FIELD, *self.type, *self.name }, dest, indent, indent_level)!;
fn void? StructNode   .to_json(&self, DString* dest, int indent, int indent_level) => serialize::add_json((StructJson){ STRUCT, *self.name, ref_arr(self.fields) }, dest, indent, indent_level)!;
fn void? InitNode     .to_json(&self, DString* dest, int indent, int indent_level) => serialize::add_json((InitJson){ INIT, ref_arr(self.values) }, dest, indent, indent_level)!;
fn void? InitValueNode.to_json(&self, DString* dest, int indent, int indent_level) => serialize::add_json((InitValueJson){ INIT_VALUE, *self.name, *self.value }, dest, indent, indent_level)!;
fn void? AccessNode   .to_json(&self, DString* dest, int indent, int indent_level) => serialize::add_json((AccessJson){ ACCESS, *self.expr, *self.next }, dest, indent, indent_level)!;
fn void? MacroNode    .to_json(&self, DString* dest, int indent, int indent_level) => serialize::add_json((MacroJson){ MACRO, *self.type, *self.name, ref_arr(self.parameters), ref_arr(self.children) }, dest, indent, indent_level)!;
fn void? UnaryNode    .to_json(&self, DString* dest, int indent, int indent_level) => serialize::add_json((UnaryJson){ UNARY, self.operator, *self.expr }, dest, indent, indent_level)!;
fn void? WhileNode    .to_json(&self, DString* dest, int indent, int indent_level) => serialize::add_json((WhileJson){ WHILE, *self.condition, ref_arr(self.children) }, dest, indent, indent_level)!;
fn void? SwitchNode   .to_json(&self, DString* dest, int indent, int indent_level) => serialize::add_json((SwitchJson){ SWITCH, *self.expression, ref_arr(self.cases) }, dest, indent, indent_level)!;
fn void? CaseNode     .to_json(&self, DString* dest, int indent, int indent_level) => serialize::add_json((CaseJson){ CASE, *self.condition, ref_arr(self.children) }, dest, indent, indent_level)!;
fn void? IncNode      .to_json(&self, DString* dest, int indent, int indent_level) => serialize::add_json((IncJson){ INC, *self.identifier, self.operator }, dest, indent, indent_level)!;
fn void? ForNode      .to_json(&self, DString* dest, int indent, int indent_level) => serialize::add_json((ForJson){ FOR, *self.statement, *self.condition, *self.expression, ref_arr(self.children) }, dest, indent, indent_level)!;
fn void? PkgNode      .to_json(&self, DString* dest, int indent, int indent_level) => serialize::add_json((PkgJson){ PKG, *self.path }, dest, indent, indent_level)!;
fn void? PathNode     .to_json(&self, DString* dest, int indent, int indent_level) => serialize::add_json((PathJson){ PATH, ref_arr(self.segments) }, dest, indent, indent_level)!;
fn void? TupleNode    .to_json(&self, DString* dest, int indent, int indent_level) => serialize::add_json((TupleJson){ TUPLE, ref_arr(self.values) }, dest, indent, indent_level)!;
fn void? NullNode     .to_json(&self, DString* dest, int indent, int indent_level) => serialize::add_json((NullJson){ NULL }, dest, indent, indent_level)!;
fn void? ReturnNode   .to_json(&self, DString* dest, int indent, int indent_level) => serialize::add_json((ReturnJson){ RETURN, ref_arr(self.values) }, dest, indent, indent_level)!;
fn void? LinkNode     .to_json(&self, DString* dest, int indent, int indent_level) => serialize::add_json((LinkJson){ LINK, *self.name }, dest, indent, indent_level)!;

fn ASTNode[] ref_arr(ASTNode*[] arr) @private
{
    ASTNode[] out = mem::new_array(ASTNode, arr.len);

    foreach (i, e : arr)
    {
        out[i] = *e;
    }

    return out;
}
