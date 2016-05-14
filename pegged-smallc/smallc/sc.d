/++
This module was automatically generated from the following grammar:

SC:
	Global   <- (Var_def / Fun_proto / Fun_def)+
	Var_def  < Type Declare (:',' Declare)* :';'
	Fun_proto < Fun_declare ';'
	Fun_def  < Fun_declare Stmts
	Fun_declare < Type Def_ID :'(' Param? (:',' Param)* :')'
	Param    < Type Def_ID
	Stmts    < ^'{' Var_def* Stmt* :'}' 
	Stmt     < ^';' 
             / ^'if' :'(' Expr :')' Stmt (:'else' Stmt)?
             / ^'while' :'(' Expr :')' Stmt               
             / ^'for' :'(' Expr? ^';' Expr? ^';' Expr? ^')' Stmt
             / ^'return' Expr? :';'
             / Stmts / Expr :';'
	Expr < Expr ^','  EB00 / EB00
	EB00 < EB01 ^'='  EB00 / EB01 
	EB01 < EB01 ^'||' EB02 / EB02
	EB02 < EB02 ^'&&' EB03 / EB03
	EB03 < EB03 (^'==' / ^'!=') EB04 / EB04
	EB04 < EB04 (^'<=' / ^'>=' / ^'<' / ^'>') EB05 / EB05
	EB05 < EB05 (^'+' / ^'-') EB06 / EB06
	EB06 < EB06 (^'*' / ^'/') Postfix_expr / Postfix_expr
	Postfix_expr < (^'-' / ^'&' / ^'*') Postfix_expr / Unary_expr
	Unary_expr   < Apply / Array / Primary_expr
	Primary_expr < ID / NUM / :'(' Expr :')'	
	Apply    < ID :'(' EB00? (:',' EB00)* :')'
	Array    < Primary_expr (:'[' Expr :']' )+
	Type     < 'int' / 'void'
	Declare  < Def_ID (:'[' NUM ']')? 
	Def_ID   < (^'*')? ID
	ID       < identifier
	NUM      < ~([0-9]+)


+/
module smallc.sc;

public import pegged.peg;
import std.algorithm: startsWith;
import std.functional: toDelegate;

/** Left-recursive cycles:
EB02
EB03
EB04
EB05
EB06
EB01
Expr
*/

/** Rules that stop left-recursive cycles, followed by rules for which
 *  memoization is blocked during recursion:
EB02: 
Expr: 
EB06: 
EB01: 
EB05: 
EB03: 
EB04: 
*/

struct GenericSC(TParseTree)
{
    import pegged.dynamic.grammar;
    struct SC
    {
    enum name = "SC";
    static ParseTree delegate(ParseTree)[string] before;
    static ParseTree delegate(ParseTree)[string] after;
    static ParseTree delegate(ParseTree)[string] rules;
    import std.typecons:Tuple, tuple;
    static TParseTree[Tuple!(string, size_t)] memo;
    import std.algorithm: canFind, countUntil, remove;
    static size_t[] blockMemo_EB02_atPos;
    static size_t[] blockMemo_EB03_atPos;
    static size_t[] blockMemo_EB04_atPos;
    static size_t[] blockMemo_EB05_atPos;
    static size_t[] blockMemo_EB06_atPos;
    static size_t[] blockMemo_EB01_atPos;
    static size_t[] blockMemo_Expr_atPos;
    static this()
    {
        rules["Global"] = toDelegate(&Global);
        rules["Var_def"] = toDelegate(&Var_def);
        rules["Fun_proto"] = toDelegate(&Fun_proto);
        rules["Fun_def"] = toDelegate(&Fun_def);
        rules["Fun_declare"] = toDelegate(&Fun_declare);
        rules["Param"] = toDelegate(&Param);
        rules["Stmts"] = toDelegate(&Stmts);
        rules["Stmt"] = toDelegate(&Stmt);
        rules["Expr"] = toDelegate(&Expr);
        rules["EB00"] = toDelegate(&EB00);
        rules["EB01"] = toDelegate(&EB01);
        rules["EB02"] = toDelegate(&EB02);
        rules["EB03"] = toDelegate(&EB03);
        rules["EB04"] = toDelegate(&EB04);
        rules["EB05"] = toDelegate(&EB05);
        rules["EB06"] = toDelegate(&EB06);
        rules["Postfix_expr"] = toDelegate(&Postfix_expr);
        rules["Unary_expr"] = toDelegate(&Unary_expr);
        rules["Primary_expr"] = toDelegate(&Primary_expr);
        rules["Apply"] = toDelegate(&Apply);
        rules["Array"] = toDelegate(&Array);
        rules["Type"] = toDelegate(&Type);
        rules["Declare"] = toDelegate(&Declare);
        rules["Def_ID"] = toDelegate(&Def_ID);
        rules["ID"] = toDelegate(&ID);
        rules["NUM"] = toDelegate(&NUM);
        rules["Spacing"] = toDelegate(&Spacing);
    }

    template hooked(alias r, string name)
    {
        static ParseTree hooked(ParseTree p)
        {
            ParseTree result;

            if (name in before)
            {
                result = before[name](p);
                if (result.successful)
                    return result;
            }

            result = r(p);
            if (result.successful || name !in after)
                return result;

            result = after[name](p);
            return result;
        }

        static ParseTree hooked(string input)
        {
            return hooked!(r, name)(ParseTree("",false,[],input));
        }
    }

    static void addRuleBefore(string parentRule, string ruleSyntax)
    {
        // enum name is the current grammar name
        DynamicGrammar dg = pegged.dynamic.grammar.grammar(name ~ ": " ~ ruleSyntax, rules);
        foreach(ruleName,rule; dg.rules)
            if (ruleName != "Spacing") // Keep the local Spacing rule, do not overwrite it
                rules[ruleName] = rule;
        before[parentRule] = rules[dg.startingRule];
    }

    static void addRuleAfter(string parentRule, string ruleSyntax)
    {
        // enum name is the current grammar named
        DynamicGrammar dg = pegged.dynamic.grammar.grammar(name ~ ": " ~ ruleSyntax, rules);
        foreach(name,rule; dg.rules)
        {
            if (name != "Spacing")
                rules[name] = rule;
        }
        after[parentRule] = rules[dg.startingRule];
    }

    static bool isRule(string s)
    {
        return s.startsWith("SC.");
    }
    mixin decimateTree;

    alias spacing Spacing;

    static TParseTree Global(TParseTree p)
    {
        if(__ctfe)
        {
            return         pegged.peg.defined!(pegged.peg.oneOrMore!(pegged.peg.or!(Var_def, Fun_proto, Fun_def)), "SC.Global")(p);
        }
        else
        {
            if (auto m = tuple(`Global`, p.end) in memo)
                return *m;
            else
            {
                TParseTree result = hooked!(pegged.peg.defined!(pegged.peg.oneOrMore!(pegged.peg.or!(Var_def, Fun_proto, Fun_def)), "SC.Global"), "Global")(p);
                memo[tuple(`Global`, p.end)] = result;
                return result;
            }
        }
    }

    static TParseTree Global(string s)
    {
        if(__ctfe)
        {
            return         pegged.peg.defined!(pegged.peg.oneOrMore!(pegged.peg.or!(Var_def, Fun_proto, Fun_def)), "SC.Global")(TParseTree("", false,[], s));
        }
        else
        {
            forgetMemo();
            return hooked!(pegged.peg.defined!(pegged.peg.oneOrMore!(pegged.peg.or!(Var_def, Fun_proto, Fun_def)), "SC.Global"), "Global")(TParseTree("", false,[], s));
        }
    }
    static string Global(GetName g)
    {
        return "SC.Global";
    }

    static TParseTree Var_def(TParseTree p)
    {
        if(__ctfe)
        {
            return         pegged.peg.defined!(pegged.peg.and!(pegged.peg.wrapAround!(Spacing, Type, Spacing), pegged.peg.wrapAround!(Spacing, Declare, Spacing), pegged.peg.zeroOrMore!(pegged.peg.wrapAround!(Spacing, pegged.peg.and!(pegged.peg.discard!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!(","), Spacing)), pegged.peg.wrapAround!(Spacing, Declare, Spacing)), Spacing)), pegged.peg.discard!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!(";"), Spacing))), "SC.Var_def")(p);
        }
        else
        {
            if (auto m = tuple(`Var_def`, p.end) in memo)
                return *m;
            else
            {
                TParseTree result = hooked!(pegged.peg.defined!(pegged.peg.and!(pegged.peg.wrapAround!(Spacing, Type, Spacing), pegged.peg.wrapAround!(Spacing, Declare, Spacing), pegged.peg.zeroOrMore!(pegged.peg.wrapAround!(Spacing, pegged.peg.and!(pegged.peg.discard!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!(","), Spacing)), pegged.peg.wrapAround!(Spacing, Declare, Spacing)), Spacing)), pegged.peg.discard!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!(";"), Spacing))), "SC.Var_def"), "Var_def")(p);
                memo[tuple(`Var_def`, p.end)] = result;
                return result;
            }
        }
    }

    static TParseTree Var_def(string s)
    {
        if(__ctfe)
        {
            return         pegged.peg.defined!(pegged.peg.and!(pegged.peg.wrapAround!(Spacing, Type, Spacing), pegged.peg.wrapAround!(Spacing, Declare, Spacing), pegged.peg.zeroOrMore!(pegged.peg.wrapAround!(Spacing, pegged.peg.and!(pegged.peg.discard!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!(","), Spacing)), pegged.peg.wrapAround!(Spacing, Declare, Spacing)), Spacing)), pegged.peg.discard!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!(";"), Spacing))), "SC.Var_def")(TParseTree("", false,[], s));
        }
        else
        {
            forgetMemo();
            return hooked!(pegged.peg.defined!(pegged.peg.and!(pegged.peg.wrapAround!(Spacing, Type, Spacing), pegged.peg.wrapAround!(Spacing, Declare, Spacing), pegged.peg.zeroOrMore!(pegged.peg.wrapAround!(Spacing, pegged.peg.and!(pegged.peg.discard!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!(","), Spacing)), pegged.peg.wrapAround!(Spacing, Declare, Spacing)), Spacing)), pegged.peg.discard!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!(";"), Spacing))), "SC.Var_def"), "Var_def")(TParseTree("", false,[], s));
        }
    }
    static string Var_def(GetName g)
    {
        return "SC.Var_def";
    }

    static TParseTree Fun_proto(TParseTree p)
    {
        if(__ctfe)
        {
            return         pegged.peg.defined!(pegged.peg.and!(pegged.peg.wrapAround!(Spacing, Fun_declare, Spacing), pegged.peg.wrapAround!(Spacing, pegged.peg.literal!(";"), Spacing)), "SC.Fun_proto")(p);
        }
        else
        {
            if (auto m = tuple(`Fun_proto`, p.end) in memo)
                return *m;
            else
            {
                TParseTree result = hooked!(pegged.peg.defined!(pegged.peg.and!(pegged.peg.wrapAround!(Spacing, Fun_declare, Spacing), pegged.peg.wrapAround!(Spacing, pegged.peg.literal!(";"), Spacing)), "SC.Fun_proto"), "Fun_proto")(p);
                memo[tuple(`Fun_proto`, p.end)] = result;
                return result;
            }
        }
    }

    static TParseTree Fun_proto(string s)
    {
        if(__ctfe)
        {
            return         pegged.peg.defined!(pegged.peg.and!(pegged.peg.wrapAround!(Spacing, Fun_declare, Spacing), pegged.peg.wrapAround!(Spacing, pegged.peg.literal!(";"), Spacing)), "SC.Fun_proto")(TParseTree("", false,[], s));
        }
        else
        {
            forgetMemo();
            return hooked!(pegged.peg.defined!(pegged.peg.and!(pegged.peg.wrapAround!(Spacing, Fun_declare, Spacing), pegged.peg.wrapAround!(Spacing, pegged.peg.literal!(";"), Spacing)), "SC.Fun_proto"), "Fun_proto")(TParseTree("", false,[], s));
        }
    }
    static string Fun_proto(GetName g)
    {
        return "SC.Fun_proto";
    }

    static TParseTree Fun_def(TParseTree p)
    {
        if(__ctfe)
        {
            return         pegged.peg.defined!(pegged.peg.and!(pegged.peg.wrapAround!(Spacing, Fun_declare, Spacing), pegged.peg.wrapAround!(Spacing, Stmts, Spacing)), "SC.Fun_def")(p);
        }
        else
        {
            if (auto m = tuple(`Fun_def`, p.end) in memo)
                return *m;
            else
            {
                TParseTree result = hooked!(pegged.peg.defined!(pegged.peg.and!(pegged.peg.wrapAround!(Spacing, Fun_declare, Spacing), pegged.peg.wrapAround!(Spacing, Stmts, Spacing)), "SC.Fun_def"), "Fun_def")(p);
                memo[tuple(`Fun_def`, p.end)] = result;
                return result;
            }
        }
    }

    static TParseTree Fun_def(string s)
    {
        if(__ctfe)
        {
            return         pegged.peg.defined!(pegged.peg.and!(pegged.peg.wrapAround!(Spacing, Fun_declare, Spacing), pegged.peg.wrapAround!(Spacing, Stmts, Spacing)), "SC.Fun_def")(TParseTree("", false,[], s));
        }
        else
        {
            forgetMemo();
            return hooked!(pegged.peg.defined!(pegged.peg.and!(pegged.peg.wrapAround!(Spacing, Fun_declare, Spacing), pegged.peg.wrapAround!(Spacing, Stmts, Spacing)), "SC.Fun_def"), "Fun_def")(TParseTree("", false,[], s));
        }
    }
    static string Fun_def(GetName g)
    {
        return "SC.Fun_def";
    }

    static TParseTree Fun_declare(TParseTree p)
    {
        if(__ctfe)
        {
            return         pegged.peg.defined!(pegged.peg.and!(pegged.peg.wrapAround!(Spacing, Type, Spacing), pegged.peg.wrapAround!(Spacing, Def_ID, Spacing), pegged.peg.discard!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("("), Spacing)), pegged.peg.option!(pegged.peg.wrapAround!(Spacing, Param, Spacing)), pegged.peg.zeroOrMore!(pegged.peg.wrapAround!(Spacing, pegged.peg.and!(pegged.peg.discard!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!(","), Spacing)), pegged.peg.wrapAround!(Spacing, Param, Spacing)), Spacing)), pegged.peg.discard!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!(")"), Spacing))), "SC.Fun_declare")(p);
        }
        else
        {
            if (auto m = tuple(`Fun_declare`, p.end) in memo)
                return *m;
            else
            {
                TParseTree result = hooked!(pegged.peg.defined!(pegged.peg.and!(pegged.peg.wrapAround!(Spacing, Type, Spacing), pegged.peg.wrapAround!(Spacing, Def_ID, Spacing), pegged.peg.discard!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("("), Spacing)), pegged.peg.option!(pegged.peg.wrapAround!(Spacing, Param, Spacing)), pegged.peg.zeroOrMore!(pegged.peg.wrapAround!(Spacing, pegged.peg.and!(pegged.peg.discard!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!(","), Spacing)), pegged.peg.wrapAround!(Spacing, Param, Spacing)), Spacing)), pegged.peg.discard!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!(")"), Spacing))), "SC.Fun_declare"), "Fun_declare")(p);
                memo[tuple(`Fun_declare`, p.end)] = result;
                return result;
            }
        }
    }

    static TParseTree Fun_declare(string s)
    {
        if(__ctfe)
        {
            return         pegged.peg.defined!(pegged.peg.and!(pegged.peg.wrapAround!(Spacing, Type, Spacing), pegged.peg.wrapAround!(Spacing, Def_ID, Spacing), pegged.peg.discard!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("("), Spacing)), pegged.peg.option!(pegged.peg.wrapAround!(Spacing, Param, Spacing)), pegged.peg.zeroOrMore!(pegged.peg.wrapAround!(Spacing, pegged.peg.and!(pegged.peg.discard!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!(","), Spacing)), pegged.peg.wrapAround!(Spacing, Param, Spacing)), Spacing)), pegged.peg.discard!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!(")"), Spacing))), "SC.Fun_declare")(TParseTree("", false,[], s));
        }
        else
        {
            forgetMemo();
            return hooked!(pegged.peg.defined!(pegged.peg.and!(pegged.peg.wrapAround!(Spacing, Type, Spacing), pegged.peg.wrapAround!(Spacing, Def_ID, Spacing), pegged.peg.discard!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("("), Spacing)), pegged.peg.option!(pegged.peg.wrapAround!(Spacing, Param, Spacing)), pegged.peg.zeroOrMore!(pegged.peg.wrapAround!(Spacing, pegged.peg.and!(pegged.peg.discard!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!(","), Spacing)), pegged.peg.wrapAround!(Spacing, Param, Spacing)), Spacing)), pegged.peg.discard!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!(")"), Spacing))), "SC.Fun_declare"), "Fun_declare")(TParseTree("", false,[], s));
        }
    }
    static string Fun_declare(GetName g)
    {
        return "SC.Fun_declare";
    }

    static TParseTree Param(TParseTree p)
    {
        if(__ctfe)
        {
            return         pegged.peg.defined!(pegged.peg.and!(pegged.peg.wrapAround!(Spacing, Type, Spacing), pegged.peg.wrapAround!(Spacing, Def_ID, Spacing)), "SC.Param")(p);
        }
        else
        {
            if (auto m = tuple(`Param`, p.end) in memo)
                return *m;
            else
            {
                TParseTree result = hooked!(pegged.peg.defined!(pegged.peg.and!(pegged.peg.wrapAround!(Spacing, Type, Spacing), pegged.peg.wrapAround!(Spacing, Def_ID, Spacing)), "SC.Param"), "Param")(p);
                memo[tuple(`Param`, p.end)] = result;
                return result;
            }
        }
    }

    static TParseTree Param(string s)
    {
        if(__ctfe)
        {
            return         pegged.peg.defined!(pegged.peg.and!(pegged.peg.wrapAround!(Spacing, Type, Spacing), pegged.peg.wrapAround!(Spacing, Def_ID, Spacing)), "SC.Param")(TParseTree("", false,[], s));
        }
        else
        {
            forgetMemo();
            return hooked!(pegged.peg.defined!(pegged.peg.and!(pegged.peg.wrapAround!(Spacing, Type, Spacing), pegged.peg.wrapAround!(Spacing, Def_ID, Spacing)), "SC.Param"), "Param")(TParseTree("", false,[], s));
        }
    }
    static string Param(GetName g)
    {
        return "SC.Param";
    }

    static TParseTree Stmts(TParseTree p)
    {
        if(__ctfe)
        {
            return         pegged.peg.defined!(pegged.peg.and!(pegged.peg.keep!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("{"), Spacing)), pegged.peg.zeroOrMore!(pegged.peg.wrapAround!(Spacing, Var_def, Spacing)), pegged.peg.zeroOrMore!(pegged.peg.wrapAround!(Spacing, Stmt, Spacing)), pegged.peg.discard!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("}"), Spacing))), "SC.Stmts")(p);
        }
        else
        {
            if (auto m = tuple(`Stmts`, p.end) in memo)
                return *m;
            else
            {
                TParseTree result = hooked!(pegged.peg.defined!(pegged.peg.and!(pegged.peg.keep!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("{"), Spacing)), pegged.peg.zeroOrMore!(pegged.peg.wrapAround!(Spacing, Var_def, Spacing)), pegged.peg.zeroOrMore!(pegged.peg.wrapAround!(Spacing, Stmt, Spacing)), pegged.peg.discard!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("}"), Spacing))), "SC.Stmts"), "Stmts")(p);
                memo[tuple(`Stmts`, p.end)] = result;
                return result;
            }
        }
    }

    static TParseTree Stmts(string s)
    {
        if(__ctfe)
        {
            return         pegged.peg.defined!(pegged.peg.and!(pegged.peg.keep!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("{"), Spacing)), pegged.peg.zeroOrMore!(pegged.peg.wrapAround!(Spacing, Var_def, Spacing)), pegged.peg.zeroOrMore!(pegged.peg.wrapAround!(Spacing, Stmt, Spacing)), pegged.peg.discard!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("}"), Spacing))), "SC.Stmts")(TParseTree("", false,[], s));
        }
        else
        {
            forgetMemo();
            return hooked!(pegged.peg.defined!(pegged.peg.and!(pegged.peg.keep!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("{"), Spacing)), pegged.peg.zeroOrMore!(pegged.peg.wrapAround!(Spacing, Var_def, Spacing)), pegged.peg.zeroOrMore!(pegged.peg.wrapAround!(Spacing, Stmt, Spacing)), pegged.peg.discard!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("}"), Spacing))), "SC.Stmts"), "Stmts")(TParseTree("", false,[], s));
        }
    }
    static string Stmts(GetName g)
    {
        return "SC.Stmts";
    }

    static TParseTree Stmt(TParseTree p)
    {
        if(__ctfe)
        {
            return         pegged.peg.defined!(pegged.peg.or!(pegged.peg.keep!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!(";"), Spacing)), pegged.peg.and!(pegged.peg.keep!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("if"), Spacing)), pegged.peg.discard!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("("), Spacing)), pegged.peg.wrapAround!(Spacing, Expr, Spacing), pegged.peg.discard!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!(")"), Spacing)), pegged.peg.wrapAround!(Spacing, Stmt, Spacing), pegged.peg.option!(pegged.peg.wrapAround!(Spacing, pegged.peg.and!(pegged.peg.discard!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("else"), Spacing)), pegged.peg.wrapAround!(Spacing, Stmt, Spacing)), Spacing))), pegged.peg.and!(pegged.peg.keep!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("while"), Spacing)), pegged.peg.discard!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("("), Spacing)), pegged.peg.wrapAround!(Spacing, Expr, Spacing), pegged.peg.discard!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!(")"), Spacing)), pegged.peg.wrapAround!(Spacing, Stmt, Spacing)), pegged.peg.and!(pegged.peg.keep!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("for"), Spacing)), pegged.peg.discard!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("("), Spacing)), pegged.peg.option!(pegged.peg.wrapAround!(Spacing, Expr, Spacing)), pegged.peg.keep!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!(";"), Spacing)), pegged.peg.option!(pegged.peg.wrapAround!(Spacing, Expr, Spacing)), pegged.peg.keep!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!(";"), Spacing)), pegged.peg.option!(pegged.peg.wrapAround!(Spacing, Expr, Spacing)), pegged.peg.keep!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!(")"), Spacing)), pegged.peg.wrapAround!(Spacing, Stmt, Spacing)), pegged.peg.and!(pegged.peg.keep!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("return"), Spacing)), pegged.peg.option!(pegged.peg.wrapAround!(Spacing, Expr, Spacing)), pegged.peg.discard!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!(";"), Spacing))), pegged.peg.wrapAround!(Spacing, Stmts, Spacing), pegged.peg.and!(pegged.peg.wrapAround!(Spacing, Expr, Spacing), pegged.peg.discard!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!(";"), Spacing)))), "SC.Stmt")(p);
        }
        else
        {
            if (auto m = tuple(`Stmt`, p.end) in memo)
                return *m;
            else
            {
                TParseTree result = hooked!(pegged.peg.defined!(pegged.peg.or!(pegged.peg.keep!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!(";"), Spacing)), pegged.peg.and!(pegged.peg.keep!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("if"), Spacing)), pegged.peg.discard!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("("), Spacing)), pegged.peg.wrapAround!(Spacing, Expr, Spacing), pegged.peg.discard!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!(")"), Spacing)), pegged.peg.wrapAround!(Spacing, Stmt, Spacing), pegged.peg.option!(pegged.peg.wrapAround!(Spacing, pegged.peg.and!(pegged.peg.discard!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("else"), Spacing)), pegged.peg.wrapAround!(Spacing, Stmt, Spacing)), Spacing))), pegged.peg.and!(pegged.peg.keep!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("while"), Spacing)), pegged.peg.discard!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("("), Spacing)), pegged.peg.wrapAround!(Spacing, Expr, Spacing), pegged.peg.discard!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!(")"), Spacing)), pegged.peg.wrapAround!(Spacing, Stmt, Spacing)), pegged.peg.and!(pegged.peg.keep!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("for"), Spacing)), pegged.peg.discard!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("("), Spacing)), pegged.peg.option!(pegged.peg.wrapAround!(Spacing, Expr, Spacing)), pegged.peg.keep!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!(";"), Spacing)), pegged.peg.option!(pegged.peg.wrapAround!(Spacing, Expr, Spacing)), pegged.peg.keep!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!(";"), Spacing)), pegged.peg.option!(pegged.peg.wrapAround!(Spacing, Expr, Spacing)), pegged.peg.keep!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!(")"), Spacing)), pegged.peg.wrapAround!(Spacing, Stmt, Spacing)), pegged.peg.and!(pegged.peg.keep!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("return"), Spacing)), pegged.peg.option!(pegged.peg.wrapAround!(Spacing, Expr, Spacing)), pegged.peg.discard!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!(";"), Spacing))), pegged.peg.wrapAround!(Spacing, Stmts, Spacing), pegged.peg.and!(pegged.peg.wrapAround!(Spacing, Expr, Spacing), pegged.peg.discard!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!(";"), Spacing)))), "SC.Stmt"), "Stmt")(p);
                memo[tuple(`Stmt`, p.end)] = result;
                return result;
            }
        }
    }

    static TParseTree Stmt(string s)
    {
        if(__ctfe)
        {
            return         pegged.peg.defined!(pegged.peg.or!(pegged.peg.keep!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!(";"), Spacing)), pegged.peg.and!(pegged.peg.keep!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("if"), Spacing)), pegged.peg.discard!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("("), Spacing)), pegged.peg.wrapAround!(Spacing, Expr, Spacing), pegged.peg.discard!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!(")"), Spacing)), pegged.peg.wrapAround!(Spacing, Stmt, Spacing), pegged.peg.option!(pegged.peg.wrapAround!(Spacing, pegged.peg.and!(pegged.peg.discard!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("else"), Spacing)), pegged.peg.wrapAround!(Spacing, Stmt, Spacing)), Spacing))), pegged.peg.and!(pegged.peg.keep!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("while"), Spacing)), pegged.peg.discard!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("("), Spacing)), pegged.peg.wrapAround!(Spacing, Expr, Spacing), pegged.peg.discard!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!(")"), Spacing)), pegged.peg.wrapAround!(Spacing, Stmt, Spacing)), pegged.peg.and!(pegged.peg.keep!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("for"), Spacing)), pegged.peg.discard!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("("), Spacing)), pegged.peg.option!(pegged.peg.wrapAround!(Spacing, Expr, Spacing)), pegged.peg.keep!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!(";"), Spacing)), pegged.peg.option!(pegged.peg.wrapAround!(Spacing, Expr, Spacing)), pegged.peg.keep!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!(";"), Spacing)), pegged.peg.option!(pegged.peg.wrapAround!(Spacing, Expr, Spacing)), pegged.peg.keep!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!(")"), Spacing)), pegged.peg.wrapAround!(Spacing, Stmt, Spacing)), pegged.peg.and!(pegged.peg.keep!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("return"), Spacing)), pegged.peg.option!(pegged.peg.wrapAround!(Spacing, Expr, Spacing)), pegged.peg.discard!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!(";"), Spacing))), pegged.peg.wrapAround!(Spacing, Stmts, Spacing), pegged.peg.and!(pegged.peg.wrapAround!(Spacing, Expr, Spacing), pegged.peg.discard!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!(";"), Spacing)))), "SC.Stmt")(TParseTree("", false,[], s));
        }
        else
        {
            forgetMemo();
            return hooked!(pegged.peg.defined!(pegged.peg.or!(pegged.peg.keep!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!(";"), Spacing)), pegged.peg.and!(pegged.peg.keep!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("if"), Spacing)), pegged.peg.discard!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("("), Spacing)), pegged.peg.wrapAround!(Spacing, Expr, Spacing), pegged.peg.discard!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!(")"), Spacing)), pegged.peg.wrapAround!(Spacing, Stmt, Spacing), pegged.peg.option!(pegged.peg.wrapAround!(Spacing, pegged.peg.and!(pegged.peg.discard!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("else"), Spacing)), pegged.peg.wrapAround!(Spacing, Stmt, Spacing)), Spacing))), pegged.peg.and!(pegged.peg.keep!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("while"), Spacing)), pegged.peg.discard!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("("), Spacing)), pegged.peg.wrapAround!(Spacing, Expr, Spacing), pegged.peg.discard!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!(")"), Spacing)), pegged.peg.wrapAround!(Spacing, Stmt, Spacing)), pegged.peg.and!(pegged.peg.keep!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("for"), Spacing)), pegged.peg.discard!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("("), Spacing)), pegged.peg.option!(pegged.peg.wrapAround!(Spacing, Expr, Spacing)), pegged.peg.keep!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!(";"), Spacing)), pegged.peg.option!(pegged.peg.wrapAround!(Spacing, Expr, Spacing)), pegged.peg.keep!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!(";"), Spacing)), pegged.peg.option!(pegged.peg.wrapAround!(Spacing, Expr, Spacing)), pegged.peg.keep!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!(")"), Spacing)), pegged.peg.wrapAround!(Spacing, Stmt, Spacing)), pegged.peg.and!(pegged.peg.keep!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("return"), Spacing)), pegged.peg.option!(pegged.peg.wrapAround!(Spacing, Expr, Spacing)), pegged.peg.discard!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!(";"), Spacing))), pegged.peg.wrapAround!(Spacing, Stmts, Spacing), pegged.peg.and!(pegged.peg.wrapAround!(Spacing, Expr, Spacing), pegged.peg.discard!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!(";"), Spacing)))), "SC.Stmt"), "Stmt")(TParseTree("", false,[], s));
        }
    }
    static string Stmt(GetName g)
    {
        return "SC.Stmt";
    }

    static TParseTree Expr(TParseTree p)
    {
        if(__ctfe)
        {
            assert(false, "Expr is left-recursive, which is not supported at compile-time. Consider using asModule().");
        }
        else
        {
            static TParseTree[size_t /*position*/] seed;
            if (auto s = p.end in seed)
                return *s;
            if (!blockMemo_Expr_atPos.canFind(p.end))
                if (auto m = tuple(`Expr`, p.end) in memo)
                    return *m;
            auto current = fail(p);
            seed[p.end] = current;
            blockMemo_Expr_atPos ~= p.end;
            while (true)
            {
                auto result = hooked!(pegged.peg.defined!(pegged.peg.or!(pegged.peg.and!(pegged.peg.wrapAround!(Spacing, Expr, Spacing), pegged.peg.keep!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!(","), Spacing)), pegged.peg.wrapAround!(Spacing, EB00, Spacing)), pegged.peg.wrapAround!(Spacing, EB00, Spacing)), "SC.Expr"), "Expr")(p);
                if (result.end > current.end ||
                    (!current.successful && result.successful) /* null-match */)
                {
                    current = result;
                    seed[p.end] = current;
                } else {
                    seed.remove(p.end);
                    assert(blockMemo_Expr_atPos.canFind(p.end));
                    remove(blockMemo_Expr_atPos, countUntil(blockMemo_Expr_atPos, p.end));
                    memo[tuple(`Expr`, p.end)] = current;
                    return current;
                }
            }
        }
    }

    static TParseTree Expr(string s)
    {
        if(__ctfe)
        {
            return         pegged.peg.defined!(pegged.peg.or!(pegged.peg.and!(pegged.peg.wrapAround!(Spacing, Expr, Spacing), pegged.peg.keep!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!(","), Spacing)), pegged.peg.wrapAround!(Spacing, EB00, Spacing)), pegged.peg.wrapAround!(Spacing, EB00, Spacing)), "SC.Expr")(TParseTree("", false,[], s));
        }
        else
        {
            forgetMemo();
            return hooked!(pegged.peg.defined!(pegged.peg.or!(pegged.peg.and!(pegged.peg.wrapAround!(Spacing, Expr, Spacing), pegged.peg.keep!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!(","), Spacing)), pegged.peg.wrapAround!(Spacing, EB00, Spacing)), pegged.peg.wrapAround!(Spacing, EB00, Spacing)), "SC.Expr"), "Expr")(TParseTree("", false,[], s));
        }
    }
    static string Expr(GetName g)
    {
        return "SC.Expr";
    }

    static TParseTree EB00(TParseTree p)
    {
        if(__ctfe)
        {
            return         pegged.peg.defined!(pegged.peg.or!(pegged.peg.and!(pegged.peg.wrapAround!(Spacing, EB01, Spacing), pegged.peg.keep!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("="), Spacing)), pegged.peg.wrapAround!(Spacing, EB00, Spacing)), pegged.peg.wrapAround!(Spacing, EB01, Spacing)), "SC.EB00")(p);
        }
        else
        {
            if (auto m = tuple(`EB00`, p.end) in memo)
                return *m;
            else
            {
                TParseTree result = hooked!(pegged.peg.defined!(pegged.peg.or!(pegged.peg.and!(pegged.peg.wrapAround!(Spacing, EB01, Spacing), pegged.peg.keep!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("="), Spacing)), pegged.peg.wrapAround!(Spacing, EB00, Spacing)), pegged.peg.wrapAround!(Spacing, EB01, Spacing)), "SC.EB00"), "EB00")(p);
                memo[tuple(`EB00`, p.end)] = result;
                return result;
            }
        }
    }

    static TParseTree EB00(string s)
    {
        if(__ctfe)
        {
            return         pegged.peg.defined!(pegged.peg.or!(pegged.peg.and!(pegged.peg.wrapAround!(Spacing, EB01, Spacing), pegged.peg.keep!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("="), Spacing)), pegged.peg.wrapAround!(Spacing, EB00, Spacing)), pegged.peg.wrapAround!(Spacing, EB01, Spacing)), "SC.EB00")(TParseTree("", false,[], s));
        }
        else
        {
            forgetMemo();
            return hooked!(pegged.peg.defined!(pegged.peg.or!(pegged.peg.and!(pegged.peg.wrapAround!(Spacing, EB01, Spacing), pegged.peg.keep!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("="), Spacing)), pegged.peg.wrapAround!(Spacing, EB00, Spacing)), pegged.peg.wrapAround!(Spacing, EB01, Spacing)), "SC.EB00"), "EB00")(TParseTree("", false,[], s));
        }
    }
    static string EB00(GetName g)
    {
        return "SC.EB00";
    }

    static TParseTree EB01(TParseTree p)
    {
        if(__ctfe)
        {
            assert(false, "EB01 is left-recursive, which is not supported at compile-time. Consider using asModule().");
        }
        else
        {
            static TParseTree[size_t /*position*/] seed;
            if (auto s = p.end in seed)
                return *s;
            if (!blockMemo_EB01_atPos.canFind(p.end))
                if (auto m = tuple(`EB01`, p.end) in memo)
                    return *m;
            auto current = fail(p);
            seed[p.end] = current;
            blockMemo_EB01_atPos ~= p.end;
            while (true)
            {
                auto result = hooked!(pegged.peg.defined!(pegged.peg.or!(pegged.peg.and!(pegged.peg.wrapAround!(Spacing, EB01, Spacing), pegged.peg.keep!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("||"), Spacing)), pegged.peg.wrapAround!(Spacing, EB02, Spacing)), pegged.peg.wrapAround!(Spacing, EB02, Spacing)), "SC.EB01"), "EB01")(p);
                if (result.end > current.end ||
                    (!current.successful && result.successful) /* null-match */)
                {
                    current = result;
                    seed[p.end] = current;
                } else {
                    seed.remove(p.end);
                    assert(blockMemo_EB01_atPos.canFind(p.end));
                    remove(blockMemo_EB01_atPos, countUntil(blockMemo_EB01_atPos, p.end));
                    memo[tuple(`EB01`, p.end)] = current;
                    return current;
                }
            }
        }
    }

    static TParseTree EB01(string s)
    {
        if(__ctfe)
        {
            return         pegged.peg.defined!(pegged.peg.or!(pegged.peg.and!(pegged.peg.wrapAround!(Spacing, EB01, Spacing), pegged.peg.keep!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("||"), Spacing)), pegged.peg.wrapAround!(Spacing, EB02, Spacing)), pegged.peg.wrapAround!(Spacing, EB02, Spacing)), "SC.EB01")(TParseTree("", false,[], s));
        }
        else
        {
            forgetMemo();
            return hooked!(pegged.peg.defined!(pegged.peg.or!(pegged.peg.and!(pegged.peg.wrapAround!(Spacing, EB01, Spacing), pegged.peg.keep!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("||"), Spacing)), pegged.peg.wrapAround!(Spacing, EB02, Spacing)), pegged.peg.wrapAround!(Spacing, EB02, Spacing)), "SC.EB01"), "EB01")(TParseTree("", false,[], s));
        }
    }
    static string EB01(GetName g)
    {
        return "SC.EB01";
    }

    static TParseTree EB02(TParseTree p)
    {
        if(__ctfe)
        {
            assert(false, "EB02 is left-recursive, which is not supported at compile-time. Consider using asModule().");
        }
        else
        {
            static TParseTree[size_t /*position*/] seed;
            if (auto s = p.end in seed)
                return *s;
            if (!blockMemo_EB02_atPos.canFind(p.end))
                if (auto m = tuple(`EB02`, p.end) in memo)
                    return *m;
            auto current = fail(p);
            seed[p.end] = current;
            blockMemo_EB02_atPos ~= p.end;
            while (true)
            {
                auto result = hooked!(pegged.peg.defined!(pegged.peg.or!(pegged.peg.and!(pegged.peg.wrapAround!(Spacing, EB02, Spacing), pegged.peg.keep!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("&&"), Spacing)), pegged.peg.wrapAround!(Spacing, EB03, Spacing)), pegged.peg.wrapAround!(Spacing, EB03, Spacing)), "SC.EB02"), "EB02")(p);
                if (result.end > current.end ||
                    (!current.successful && result.successful) /* null-match */)
                {
                    current = result;
                    seed[p.end] = current;
                } else {
                    seed.remove(p.end);
                    assert(blockMemo_EB02_atPos.canFind(p.end));
                    remove(blockMemo_EB02_atPos, countUntil(blockMemo_EB02_atPos, p.end));
                    memo[tuple(`EB02`, p.end)] = current;
                    return current;
                }
            }
        }
    }

    static TParseTree EB02(string s)
    {
        if(__ctfe)
        {
            return         pegged.peg.defined!(pegged.peg.or!(pegged.peg.and!(pegged.peg.wrapAround!(Spacing, EB02, Spacing), pegged.peg.keep!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("&&"), Spacing)), pegged.peg.wrapAround!(Spacing, EB03, Spacing)), pegged.peg.wrapAround!(Spacing, EB03, Spacing)), "SC.EB02")(TParseTree("", false,[], s));
        }
        else
        {
            forgetMemo();
            return hooked!(pegged.peg.defined!(pegged.peg.or!(pegged.peg.and!(pegged.peg.wrapAround!(Spacing, EB02, Spacing), pegged.peg.keep!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("&&"), Spacing)), pegged.peg.wrapAround!(Spacing, EB03, Spacing)), pegged.peg.wrapAround!(Spacing, EB03, Spacing)), "SC.EB02"), "EB02")(TParseTree("", false,[], s));
        }
    }
    static string EB02(GetName g)
    {
        return "SC.EB02";
    }

    static TParseTree EB03(TParseTree p)
    {
        if(__ctfe)
        {
            assert(false, "EB03 is left-recursive, which is not supported at compile-time. Consider using asModule().");
        }
        else
        {
            static TParseTree[size_t /*position*/] seed;
            if (auto s = p.end in seed)
                return *s;
            if (!blockMemo_EB03_atPos.canFind(p.end))
                if (auto m = tuple(`EB03`, p.end) in memo)
                    return *m;
            auto current = fail(p);
            seed[p.end] = current;
            blockMemo_EB03_atPos ~= p.end;
            while (true)
            {
                auto result = hooked!(pegged.peg.defined!(pegged.peg.or!(pegged.peg.and!(pegged.peg.wrapAround!(Spacing, EB03, Spacing), pegged.peg.wrapAround!(Spacing, pegged.peg.or!(pegged.peg.keep!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("=="), Spacing)), pegged.peg.keep!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("!="), Spacing))), Spacing), pegged.peg.wrapAround!(Spacing, EB04, Spacing)), pegged.peg.wrapAround!(Spacing, EB04, Spacing)), "SC.EB03"), "EB03")(p);
                if (result.end > current.end ||
                    (!current.successful && result.successful) /* null-match */)
                {
                    current = result;
                    seed[p.end] = current;
                } else {
                    seed.remove(p.end);
                    assert(blockMemo_EB03_atPos.canFind(p.end));
                    remove(blockMemo_EB03_atPos, countUntil(blockMemo_EB03_atPos, p.end));
                    memo[tuple(`EB03`, p.end)] = current;
                    return current;
                }
            }
        }
    }

    static TParseTree EB03(string s)
    {
        if(__ctfe)
        {
            return         pegged.peg.defined!(pegged.peg.or!(pegged.peg.and!(pegged.peg.wrapAround!(Spacing, EB03, Spacing), pegged.peg.wrapAround!(Spacing, pegged.peg.or!(pegged.peg.keep!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("=="), Spacing)), pegged.peg.keep!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("!="), Spacing))), Spacing), pegged.peg.wrapAround!(Spacing, EB04, Spacing)), pegged.peg.wrapAround!(Spacing, EB04, Spacing)), "SC.EB03")(TParseTree("", false,[], s));
        }
        else
        {
            forgetMemo();
            return hooked!(pegged.peg.defined!(pegged.peg.or!(pegged.peg.and!(pegged.peg.wrapAround!(Spacing, EB03, Spacing), pegged.peg.wrapAround!(Spacing, pegged.peg.or!(pegged.peg.keep!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("=="), Spacing)), pegged.peg.keep!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("!="), Spacing))), Spacing), pegged.peg.wrapAround!(Spacing, EB04, Spacing)), pegged.peg.wrapAround!(Spacing, EB04, Spacing)), "SC.EB03"), "EB03")(TParseTree("", false,[], s));
        }
    }
    static string EB03(GetName g)
    {
        return "SC.EB03";
    }

    static TParseTree EB04(TParseTree p)
    {
        if(__ctfe)
        {
            assert(false, "EB04 is left-recursive, which is not supported at compile-time. Consider using asModule().");
        }
        else
        {
            static TParseTree[size_t /*position*/] seed;
            if (auto s = p.end in seed)
                return *s;
            if (!blockMemo_EB04_atPos.canFind(p.end))
                if (auto m = tuple(`EB04`, p.end) in memo)
                    return *m;
            auto current = fail(p);
            seed[p.end] = current;
            blockMemo_EB04_atPos ~= p.end;
            while (true)
            {
                auto result = hooked!(pegged.peg.defined!(pegged.peg.or!(pegged.peg.and!(pegged.peg.wrapAround!(Spacing, EB04, Spacing), pegged.peg.wrapAround!(Spacing, pegged.peg.or!(pegged.peg.keep!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("<="), Spacing)), pegged.peg.keep!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!(">="), Spacing)), pegged.peg.keep!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("<"), Spacing)), pegged.peg.keep!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!(">"), Spacing))), Spacing), pegged.peg.wrapAround!(Spacing, EB05, Spacing)), pegged.peg.wrapAround!(Spacing, EB05, Spacing)), "SC.EB04"), "EB04")(p);
                if (result.end > current.end ||
                    (!current.successful && result.successful) /* null-match */)
                {
                    current = result;
                    seed[p.end] = current;
                } else {
                    seed.remove(p.end);
                    assert(blockMemo_EB04_atPos.canFind(p.end));
                    remove(blockMemo_EB04_atPos, countUntil(blockMemo_EB04_atPos, p.end));
                    memo[tuple(`EB04`, p.end)] = current;
                    return current;
                }
            }
        }
    }

    static TParseTree EB04(string s)
    {
        if(__ctfe)
        {
            return         pegged.peg.defined!(pegged.peg.or!(pegged.peg.and!(pegged.peg.wrapAround!(Spacing, EB04, Spacing), pegged.peg.wrapAround!(Spacing, pegged.peg.or!(pegged.peg.keep!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("<="), Spacing)), pegged.peg.keep!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!(">="), Spacing)), pegged.peg.keep!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("<"), Spacing)), pegged.peg.keep!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!(">"), Spacing))), Spacing), pegged.peg.wrapAround!(Spacing, EB05, Spacing)), pegged.peg.wrapAround!(Spacing, EB05, Spacing)), "SC.EB04")(TParseTree("", false,[], s));
        }
        else
        {
            forgetMemo();
            return hooked!(pegged.peg.defined!(pegged.peg.or!(pegged.peg.and!(pegged.peg.wrapAround!(Spacing, EB04, Spacing), pegged.peg.wrapAround!(Spacing, pegged.peg.or!(pegged.peg.keep!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("<="), Spacing)), pegged.peg.keep!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!(">="), Spacing)), pegged.peg.keep!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("<"), Spacing)), pegged.peg.keep!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!(">"), Spacing))), Spacing), pegged.peg.wrapAround!(Spacing, EB05, Spacing)), pegged.peg.wrapAround!(Spacing, EB05, Spacing)), "SC.EB04"), "EB04")(TParseTree("", false,[], s));
        }
    }
    static string EB04(GetName g)
    {
        return "SC.EB04";
    }

    static TParseTree EB05(TParseTree p)
    {
        if(__ctfe)
        {
            assert(false, "EB05 is left-recursive, which is not supported at compile-time. Consider using asModule().");
        }
        else
        {
            static TParseTree[size_t /*position*/] seed;
            if (auto s = p.end in seed)
                return *s;
            if (!blockMemo_EB05_atPos.canFind(p.end))
                if (auto m = tuple(`EB05`, p.end) in memo)
                    return *m;
            auto current = fail(p);
            seed[p.end] = current;
            blockMemo_EB05_atPos ~= p.end;
            while (true)
            {
                auto result = hooked!(pegged.peg.defined!(pegged.peg.or!(pegged.peg.and!(pegged.peg.wrapAround!(Spacing, EB05, Spacing), pegged.peg.wrapAround!(Spacing, pegged.peg.or!(pegged.peg.keep!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("+"), Spacing)), pegged.peg.keep!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("-"), Spacing))), Spacing), pegged.peg.wrapAround!(Spacing, EB06, Spacing)), pegged.peg.wrapAround!(Spacing, EB06, Spacing)), "SC.EB05"), "EB05")(p);
                if (result.end > current.end ||
                    (!current.successful && result.successful) /* null-match */)
                {
                    current = result;
                    seed[p.end] = current;
                } else {
                    seed.remove(p.end);
                    assert(blockMemo_EB05_atPos.canFind(p.end));
                    remove(blockMemo_EB05_atPos, countUntil(blockMemo_EB05_atPos, p.end));
                    memo[tuple(`EB05`, p.end)] = current;
                    return current;
                }
            }
        }
    }

    static TParseTree EB05(string s)
    {
        if(__ctfe)
        {
            return         pegged.peg.defined!(pegged.peg.or!(pegged.peg.and!(pegged.peg.wrapAround!(Spacing, EB05, Spacing), pegged.peg.wrapAround!(Spacing, pegged.peg.or!(pegged.peg.keep!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("+"), Spacing)), pegged.peg.keep!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("-"), Spacing))), Spacing), pegged.peg.wrapAround!(Spacing, EB06, Spacing)), pegged.peg.wrapAround!(Spacing, EB06, Spacing)), "SC.EB05")(TParseTree("", false,[], s));
        }
        else
        {
            forgetMemo();
            return hooked!(pegged.peg.defined!(pegged.peg.or!(pegged.peg.and!(pegged.peg.wrapAround!(Spacing, EB05, Spacing), pegged.peg.wrapAround!(Spacing, pegged.peg.or!(pegged.peg.keep!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("+"), Spacing)), pegged.peg.keep!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("-"), Spacing))), Spacing), pegged.peg.wrapAround!(Spacing, EB06, Spacing)), pegged.peg.wrapAround!(Spacing, EB06, Spacing)), "SC.EB05"), "EB05")(TParseTree("", false,[], s));
        }
    }
    static string EB05(GetName g)
    {
        return "SC.EB05";
    }

    static TParseTree EB06(TParseTree p)
    {
        if(__ctfe)
        {
            assert(false, "EB06 is left-recursive, which is not supported at compile-time. Consider using asModule().");
        }
        else
        {
            static TParseTree[size_t /*position*/] seed;
            if (auto s = p.end in seed)
                return *s;
            if (!blockMemo_EB06_atPos.canFind(p.end))
                if (auto m = tuple(`EB06`, p.end) in memo)
                    return *m;
            auto current = fail(p);
            seed[p.end] = current;
            blockMemo_EB06_atPos ~= p.end;
            while (true)
            {
                auto result = hooked!(pegged.peg.defined!(pegged.peg.or!(pegged.peg.and!(pegged.peg.wrapAround!(Spacing, EB06, Spacing), pegged.peg.wrapAround!(Spacing, pegged.peg.or!(pegged.peg.keep!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("*"), Spacing)), pegged.peg.keep!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("/"), Spacing))), Spacing), pegged.peg.wrapAround!(Spacing, Postfix_expr, Spacing)), pegged.peg.wrapAround!(Spacing, Postfix_expr, Spacing)), "SC.EB06"), "EB06")(p);
                if (result.end > current.end ||
                    (!current.successful && result.successful) /* null-match */)
                {
                    current = result;
                    seed[p.end] = current;
                } else {
                    seed.remove(p.end);
                    assert(blockMemo_EB06_atPos.canFind(p.end));
                    remove(blockMemo_EB06_atPos, countUntil(blockMemo_EB06_atPos, p.end));
                    memo[tuple(`EB06`, p.end)] = current;
                    return current;
                }
            }
        }
    }

    static TParseTree EB06(string s)
    {
        if(__ctfe)
        {
            return         pegged.peg.defined!(pegged.peg.or!(pegged.peg.and!(pegged.peg.wrapAround!(Spacing, EB06, Spacing), pegged.peg.wrapAround!(Spacing, pegged.peg.or!(pegged.peg.keep!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("*"), Spacing)), pegged.peg.keep!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("/"), Spacing))), Spacing), pegged.peg.wrapAround!(Spacing, Postfix_expr, Spacing)), pegged.peg.wrapAround!(Spacing, Postfix_expr, Spacing)), "SC.EB06")(TParseTree("", false,[], s));
        }
        else
        {
            forgetMemo();
            return hooked!(pegged.peg.defined!(pegged.peg.or!(pegged.peg.and!(pegged.peg.wrapAround!(Spacing, EB06, Spacing), pegged.peg.wrapAround!(Spacing, pegged.peg.or!(pegged.peg.keep!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("*"), Spacing)), pegged.peg.keep!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("/"), Spacing))), Spacing), pegged.peg.wrapAround!(Spacing, Postfix_expr, Spacing)), pegged.peg.wrapAround!(Spacing, Postfix_expr, Spacing)), "SC.EB06"), "EB06")(TParseTree("", false,[], s));
        }
    }
    static string EB06(GetName g)
    {
        return "SC.EB06";
    }

    static TParseTree Postfix_expr(TParseTree p)
    {
        if(__ctfe)
        {
            return         pegged.peg.defined!(pegged.peg.or!(pegged.peg.and!(pegged.peg.wrapAround!(Spacing, pegged.peg.or!(pegged.peg.keep!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("-"), Spacing)), pegged.peg.keep!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("&"), Spacing)), pegged.peg.keep!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("*"), Spacing))), Spacing), pegged.peg.wrapAround!(Spacing, Postfix_expr, Spacing)), pegged.peg.wrapAround!(Spacing, Unary_expr, Spacing)), "SC.Postfix_expr")(p);
        }
        else
        {
            if (auto m = tuple(`Postfix_expr`, p.end) in memo)
                return *m;
            else
            {
                TParseTree result = hooked!(pegged.peg.defined!(pegged.peg.or!(pegged.peg.and!(pegged.peg.wrapAround!(Spacing, pegged.peg.or!(pegged.peg.keep!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("-"), Spacing)), pegged.peg.keep!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("&"), Spacing)), pegged.peg.keep!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("*"), Spacing))), Spacing), pegged.peg.wrapAround!(Spacing, Postfix_expr, Spacing)), pegged.peg.wrapAround!(Spacing, Unary_expr, Spacing)), "SC.Postfix_expr"), "Postfix_expr")(p);
                memo[tuple(`Postfix_expr`, p.end)] = result;
                return result;
            }
        }
    }

    static TParseTree Postfix_expr(string s)
    {
        if(__ctfe)
        {
            return         pegged.peg.defined!(pegged.peg.or!(pegged.peg.and!(pegged.peg.wrapAround!(Spacing, pegged.peg.or!(pegged.peg.keep!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("-"), Spacing)), pegged.peg.keep!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("&"), Spacing)), pegged.peg.keep!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("*"), Spacing))), Spacing), pegged.peg.wrapAround!(Spacing, Postfix_expr, Spacing)), pegged.peg.wrapAround!(Spacing, Unary_expr, Spacing)), "SC.Postfix_expr")(TParseTree("", false,[], s));
        }
        else
        {
            forgetMemo();
            return hooked!(pegged.peg.defined!(pegged.peg.or!(pegged.peg.and!(pegged.peg.wrapAround!(Spacing, pegged.peg.or!(pegged.peg.keep!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("-"), Spacing)), pegged.peg.keep!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("&"), Spacing)), pegged.peg.keep!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("*"), Spacing))), Spacing), pegged.peg.wrapAround!(Spacing, Postfix_expr, Spacing)), pegged.peg.wrapAround!(Spacing, Unary_expr, Spacing)), "SC.Postfix_expr"), "Postfix_expr")(TParseTree("", false,[], s));
        }
    }
    static string Postfix_expr(GetName g)
    {
        return "SC.Postfix_expr";
    }

    static TParseTree Unary_expr(TParseTree p)
    {
        if(__ctfe)
        {
            return         pegged.peg.defined!(pegged.peg.or!(pegged.peg.wrapAround!(Spacing, Apply, Spacing), pegged.peg.wrapAround!(Spacing, Array, Spacing), pegged.peg.wrapAround!(Spacing, Primary_expr, Spacing)), "SC.Unary_expr")(p);
        }
        else
        {
            if (auto m = tuple(`Unary_expr`, p.end) in memo)
                return *m;
            else
            {
                TParseTree result = hooked!(pegged.peg.defined!(pegged.peg.or!(pegged.peg.wrapAround!(Spacing, Apply, Spacing), pegged.peg.wrapAround!(Spacing, Array, Spacing), pegged.peg.wrapAround!(Spacing, Primary_expr, Spacing)), "SC.Unary_expr"), "Unary_expr")(p);
                memo[tuple(`Unary_expr`, p.end)] = result;
                return result;
            }
        }
    }

    static TParseTree Unary_expr(string s)
    {
        if(__ctfe)
        {
            return         pegged.peg.defined!(pegged.peg.or!(pegged.peg.wrapAround!(Spacing, Apply, Spacing), pegged.peg.wrapAround!(Spacing, Array, Spacing), pegged.peg.wrapAround!(Spacing, Primary_expr, Spacing)), "SC.Unary_expr")(TParseTree("", false,[], s));
        }
        else
        {
            forgetMemo();
            return hooked!(pegged.peg.defined!(pegged.peg.or!(pegged.peg.wrapAround!(Spacing, Apply, Spacing), pegged.peg.wrapAround!(Spacing, Array, Spacing), pegged.peg.wrapAround!(Spacing, Primary_expr, Spacing)), "SC.Unary_expr"), "Unary_expr")(TParseTree("", false,[], s));
        }
    }
    static string Unary_expr(GetName g)
    {
        return "SC.Unary_expr";
    }

    static TParseTree Primary_expr(TParseTree p)
    {
        if(__ctfe)
        {
            return         pegged.peg.defined!(pegged.peg.or!(pegged.peg.wrapAround!(Spacing, ID, Spacing), pegged.peg.wrapAround!(Spacing, NUM, Spacing), pegged.peg.and!(pegged.peg.discard!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("("), Spacing)), pegged.peg.wrapAround!(Spacing, Expr, Spacing), pegged.peg.discard!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!(")"), Spacing)))), "SC.Primary_expr")(p);
        }
        else
        {
            if (auto m = tuple(`Primary_expr`, p.end) in memo)
                return *m;
            else
            {
                TParseTree result = hooked!(pegged.peg.defined!(pegged.peg.or!(pegged.peg.wrapAround!(Spacing, ID, Spacing), pegged.peg.wrapAround!(Spacing, NUM, Spacing), pegged.peg.and!(pegged.peg.discard!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("("), Spacing)), pegged.peg.wrapAround!(Spacing, Expr, Spacing), pegged.peg.discard!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!(")"), Spacing)))), "SC.Primary_expr"), "Primary_expr")(p);
                memo[tuple(`Primary_expr`, p.end)] = result;
                return result;
            }
        }
    }

    static TParseTree Primary_expr(string s)
    {
        if(__ctfe)
        {
            return         pegged.peg.defined!(pegged.peg.or!(pegged.peg.wrapAround!(Spacing, ID, Spacing), pegged.peg.wrapAround!(Spacing, NUM, Spacing), pegged.peg.and!(pegged.peg.discard!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("("), Spacing)), pegged.peg.wrapAround!(Spacing, Expr, Spacing), pegged.peg.discard!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!(")"), Spacing)))), "SC.Primary_expr")(TParseTree("", false,[], s));
        }
        else
        {
            forgetMemo();
            return hooked!(pegged.peg.defined!(pegged.peg.or!(pegged.peg.wrapAround!(Spacing, ID, Spacing), pegged.peg.wrapAround!(Spacing, NUM, Spacing), pegged.peg.and!(pegged.peg.discard!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("("), Spacing)), pegged.peg.wrapAround!(Spacing, Expr, Spacing), pegged.peg.discard!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!(")"), Spacing)))), "SC.Primary_expr"), "Primary_expr")(TParseTree("", false,[], s));
        }
    }
    static string Primary_expr(GetName g)
    {
        return "SC.Primary_expr";
    }

    static TParseTree Apply(TParseTree p)
    {
        if(__ctfe)
        {
            return         pegged.peg.defined!(pegged.peg.and!(pegged.peg.wrapAround!(Spacing, ID, Spacing), pegged.peg.discard!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("("), Spacing)), pegged.peg.option!(pegged.peg.wrapAround!(Spacing, EB00, Spacing)), pegged.peg.zeroOrMore!(pegged.peg.wrapAround!(Spacing, pegged.peg.and!(pegged.peg.discard!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!(","), Spacing)), pegged.peg.wrapAround!(Spacing, EB00, Spacing)), Spacing)), pegged.peg.discard!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!(")"), Spacing))), "SC.Apply")(p);
        }
        else
        {
            if (auto m = tuple(`Apply`, p.end) in memo)
                return *m;
            else
            {
                TParseTree result = hooked!(pegged.peg.defined!(pegged.peg.and!(pegged.peg.wrapAround!(Spacing, ID, Spacing), pegged.peg.discard!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("("), Spacing)), pegged.peg.option!(pegged.peg.wrapAround!(Spacing, EB00, Spacing)), pegged.peg.zeroOrMore!(pegged.peg.wrapAround!(Spacing, pegged.peg.and!(pegged.peg.discard!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!(","), Spacing)), pegged.peg.wrapAround!(Spacing, EB00, Spacing)), Spacing)), pegged.peg.discard!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!(")"), Spacing))), "SC.Apply"), "Apply")(p);
                memo[tuple(`Apply`, p.end)] = result;
                return result;
            }
        }
    }

    static TParseTree Apply(string s)
    {
        if(__ctfe)
        {
            return         pegged.peg.defined!(pegged.peg.and!(pegged.peg.wrapAround!(Spacing, ID, Spacing), pegged.peg.discard!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("("), Spacing)), pegged.peg.option!(pegged.peg.wrapAround!(Spacing, EB00, Spacing)), pegged.peg.zeroOrMore!(pegged.peg.wrapAround!(Spacing, pegged.peg.and!(pegged.peg.discard!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!(","), Spacing)), pegged.peg.wrapAround!(Spacing, EB00, Spacing)), Spacing)), pegged.peg.discard!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!(")"), Spacing))), "SC.Apply")(TParseTree("", false,[], s));
        }
        else
        {
            forgetMemo();
            return hooked!(pegged.peg.defined!(pegged.peg.and!(pegged.peg.wrapAround!(Spacing, ID, Spacing), pegged.peg.discard!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("("), Spacing)), pegged.peg.option!(pegged.peg.wrapAround!(Spacing, EB00, Spacing)), pegged.peg.zeroOrMore!(pegged.peg.wrapAround!(Spacing, pegged.peg.and!(pegged.peg.discard!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!(","), Spacing)), pegged.peg.wrapAround!(Spacing, EB00, Spacing)), Spacing)), pegged.peg.discard!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!(")"), Spacing))), "SC.Apply"), "Apply")(TParseTree("", false,[], s));
        }
    }
    static string Apply(GetName g)
    {
        return "SC.Apply";
    }

    static TParseTree Array(TParseTree p)
    {
        if(__ctfe)
        {
            return         pegged.peg.defined!(pegged.peg.and!(pegged.peg.wrapAround!(Spacing, Primary_expr, Spacing), pegged.peg.oneOrMore!(pegged.peg.wrapAround!(Spacing, pegged.peg.and!(pegged.peg.discard!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("["), Spacing)), pegged.peg.wrapAround!(Spacing, Expr, Spacing), pegged.peg.discard!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("]"), Spacing))), Spacing))), "SC.Array")(p);
        }
        else
        {
            if (auto m = tuple(`Array`, p.end) in memo)
                return *m;
            else
            {
                TParseTree result = hooked!(pegged.peg.defined!(pegged.peg.and!(pegged.peg.wrapAround!(Spacing, Primary_expr, Spacing), pegged.peg.oneOrMore!(pegged.peg.wrapAround!(Spacing, pegged.peg.and!(pegged.peg.discard!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("["), Spacing)), pegged.peg.wrapAround!(Spacing, Expr, Spacing), pegged.peg.discard!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("]"), Spacing))), Spacing))), "SC.Array"), "Array")(p);
                memo[tuple(`Array`, p.end)] = result;
                return result;
            }
        }
    }

    static TParseTree Array(string s)
    {
        if(__ctfe)
        {
            return         pegged.peg.defined!(pegged.peg.and!(pegged.peg.wrapAround!(Spacing, Primary_expr, Spacing), pegged.peg.oneOrMore!(pegged.peg.wrapAround!(Spacing, pegged.peg.and!(pegged.peg.discard!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("["), Spacing)), pegged.peg.wrapAround!(Spacing, Expr, Spacing), pegged.peg.discard!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("]"), Spacing))), Spacing))), "SC.Array")(TParseTree("", false,[], s));
        }
        else
        {
            forgetMemo();
            return hooked!(pegged.peg.defined!(pegged.peg.and!(pegged.peg.wrapAround!(Spacing, Primary_expr, Spacing), pegged.peg.oneOrMore!(pegged.peg.wrapAround!(Spacing, pegged.peg.and!(pegged.peg.discard!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("["), Spacing)), pegged.peg.wrapAround!(Spacing, Expr, Spacing), pegged.peg.discard!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("]"), Spacing))), Spacing))), "SC.Array"), "Array")(TParseTree("", false,[], s));
        }
    }
    static string Array(GetName g)
    {
        return "SC.Array";
    }

    static TParseTree Type(TParseTree p)
    {
        if(__ctfe)
        {
            return         pegged.peg.defined!(pegged.peg.or!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("int"), Spacing), pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("void"), Spacing)), "SC.Type")(p);
        }
        else
        {
            if (auto m = tuple(`Type`, p.end) in memo)
                return *m;
            else
            {
                TParseTree result = hooked!(pegged.peg.defined!(pegged.peg.or!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("int"), Spacing), pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("void"), Spacing)), "SC.Type"), "Type")(p);
                memo[tuple(`Type`, p.end)] = result;
                return result;
            }
        }
    }

    static TParseTree Type(string s)
    {
        if(__ctfe)
        {
            return         pegged.peg.defined!(pegged.peg.or!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("int"), Spacing), pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("void"), Spacing)), "SC.Type")(TParseTree("", false,[], s));
        }
        else
        {
            forgetMemo();
            return hooked!(pegged.peg.defined!(pegged.peg.or!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("int"), Spacing), pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("void"), Spacing)), "SC.Type"), "Type")(TParseTree("", false,[], s));
        }
    }
    static string Type(GetName g)
    {
        return "SC.Type";
    }

    static TParseTree Declare(TParseTree p)
    {
        if(__ctfe)
        {
            return         pegged.peg.defined!(pegged.peg.and!(pegged.peg.wrapAround!(Spacing, Def_ID, Spacing), pegged.peg.option!(pegged.peg.wrapAround!(Spacing, pegged.peg.and!(pegged.peg.discard!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("["), Spacing)), pegged.peg.wrapAround!(Spacing, NUM, Spacing), pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("]"), Spacing)), Spacing))), "SC.Declare")(p);
        }
        else
        {
            if (auto m = tuple(`Declare`, p.end) in memo)
                return *m;
            else
            {
                TParseTree result = hooked!(pegged.peg.defined!(pegged.peg.and!(pegged.peg.wrapAround!(Spacing, Def_ID, Spacing), pegged.peg.option!(pegged.peg.wrapAround!(Spacing, pegged.peg.and!(pegged.peg.discard!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("["), Spacing)), pegged.peg.wrapAround!(Spacing, NUM, Spacing), pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("]"), Spacing)), Spacing))), "SC.Declare"), "Declare")(p);
                memo[tuple(`Declare`, p.end)] = result;
                return result;
            }
        }
    }

    static TParseTree Declare(string s)
    {
        if(__ctfe)
        {
            return         pegged.peg.defined!(pegged.peg.and!(pegged.peg.wrapAround!(Spacing, Def_ID, Spacing), pegged.peg.option!(pegged.peg.wrapAround!(Spacing, pegged.peg.and!(pegged.peg.discard!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("["), Spacing)), pegged.peg.wrapAround!(Spacing, NUM, Spacing), pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("]"), Spacing)), Spacing))), "SC.Declare")(TParseTree("", false,[], s));
        }
        else
        {
            forgetMemo();
            return hooked!(pegged.peg.defined!(pegged.peg.and!(pegged.peg.wrapAround!(Spacing, Def_ID, Spacing), pegged.peg.option!(pegged.peg.wrapAround!(Spacing, pegged.peg.and!(pegged.peg.discard!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("["), Spacing)), pegged.peg.wrapAround!(Spacing, NUM, Spacing), pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("]"), Spacing)), Spacing))), "SC.Declare"), "Declare")(TParseTree("", false,[], s));
        }
    }
    static string Declare(GetName g)
    {
        return "SC.Declare";
    }

    static TParseTree Def_ID(TParseTree p)
    {
        if(__ctfe)
        {
            return         pegged.peg.defined!(pegged.peg.and!(pegged.peg.option!(pegged.peg.wrapAround!(Spacing, pegged.peg.keep!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("*"), Spacing)), Spacing)), pegged.peg.wrapAround!(Spacing, ID, Spacing)), "SC.Def_ID")(p);
        }
        else
        {
            if (auto m = tuple(`Def_ID`, p.end) in memo)
                return *m;
            else
            {
                TParseTree result = hooked!(pegged.peg.defined!(pegged.peg.and!(pegged.peg.option!(pegged.peg.wrapAround!(Spacing, pegged.peg.keep!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("*"), Spacing)), Spacing)), pegged.peg.wrapAround!(Spacing, ID, Spacing)), "SC.Def_ID"), "Def_ID")(p);
                memo[tuple(`Def_ID`, p.end)] = result;
                return result;
            }
        }
    }

    static TParseTree Def_ID(string s)
    {
        if(__ctfe)
        {
            return         pegged.peg.defined!(pegged.peg.and!(pegged.peg.option!(pegged.peg.wrapAround!(Spacing, pegged.peg.keep!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("*"), Spacing)), Spacing)), pegged.peg.wrapAround!(Spacing, ID, Spacing)), "SC.Def_ID")(TParseTree("", false,[], s));
        }
        else
        {
            forgetMemo();
            return hooked!(pegged.peg.defined!(pegged.peg.and!(pegged.peg.option!(pegged.peg.wrapAround!(Spacing, pegged.peg.keep!(pegged.peg.wrapAround!(Spacing, pegged.peg.literal!("*"), Spacing)), Spacing)), pegged.peg.wrapAround!(Spacing, ID, Spacing)), "SC.Def_ID"), "Def_ID")(TParseTree("", false,[], s));
        }
    }
    static string Def_ID(GetName g)
    {
        return "SC.Def_ID";
    }

    static TParseTree ID(TParseTree p)
    {
        if(__ctfe)
        {
            return         pegged.peg.defined!(pegged.peg.wrapAround!(Spacing, identifier, Spacing), "SC.ID")(p);
        }
        else
        {
            if (auto m = tuple(`ID`, p.end) in memo)
                return *m;
            else
            {
                TParseTree result = hooked!(pegged.peg.defined!(pegged.peg.wrapAround!(Spacing, identifier, Spacing), "SC.ID"), "ID")(p);
                memo[tuple(`ID`, p.end)] = result;
                return result;
            }
        }
    }

    static TParseTree ID(string s)
    {
        if(__ctfe)
        {
            return         pegged.peg.defined!(pegged.peg.wrapAround!(Spacing, identifier, Spacing), "SC.ID")(TParseTree("", false,[], s));
        }
        else
        {
            forgetMemo();
            return hooked!(pegged.peg.defined!(pegged.peg.wrapAround!(Spacing, identifier, Spacing), "SC.ID"), "ID")(TParseTree("", false,[], s));
        }
    }
    static string ID(GetName g)
    {
        return "SC.ID";
    }

    static TParseTree NUM(TParseTree p)
    {
        if(__ctfe)
        {
            return         pegged.peg.defined!(pegged.peg.fuse!(pegged.peg.wrapAround!(Spacing, pegged.peg.oneOrMore!(pegged.peg.wrapAround!(Spacing, pegged.peg.charRange!('0', '9'), Spacing)), Spacing)), "SC.NUM")(p);
        }
        else
        {
            if (auto m = tuple(`NUM`, p.end) in memo)
                return *m;
            else
            {
                TParseTree result = hooked!(pegged.peg.defined!(pegged.peg.fuse!(pegged.peg.wrapAround!(Spacing, pegged.peg.oneOrMore!(pegged.peg.wrapAround!(Spacing, pegged.peg.charRange!('0', '9'), Spacing)), Spacing)), "SC.NUM"), "NUM")(p);
                memo[tuple(`NUM`, p.end)] = result;
                return result;
            }
        }
    }

    static TParseTree NUM(string s)
    {
        if(__ctfe)
        {
            return         pegged.peg.defined!(pegged.peg.fuse!(pegged.peg.wrapAround!(Spacing, pegged.peg.oneOrMore!(pegged.peg.wrapAround!(Spacing, pegged.peg.charRange!('0', '9'), Spacing)), Spacing)), "SC.NUM")(TParseTree("", false,[], s));
        }
        else
        {
            forgetMemo();
            return hooked!(pegged.peg.defined!(pegged.peg.fuse!(pegged.peg.wrapAround!(Spacing, pegged.peg.oneOrMore!(pegged.peg.wrapAround!(Spacing, pegged.peg.charRange!('0', '9'), Spacing)), Spacing)), "SC.NUM"), "NUM")(TParseTree("", false,[], s));
        }
    }
    static string NUM(GetName g)
    {
        return "SC.NUM";
    }

    static TParseTree opCall(TParseTree p)
    {
        TParseTree result = decimateTree(Global(p));
        result.children = [result];
        result.name = "SC";
        return result;
    }

    static TParseTree opCall(string input)
    {
        if(__ctfe)
        {
            return SC(TParseTree(``, false, [], input, 0, 0));
        }
        else
        {
            forgetMemo();
            return SC(TParseTree(``, false, [], input, 0, 0));
        }
    }
    static string opCall(GetName g)
    {
        return "SC";
    }


    static void forgetMemo()
    {
        memo = null;
    }
    }
}

alias GenericSC!(ParseTree).SC SC;

