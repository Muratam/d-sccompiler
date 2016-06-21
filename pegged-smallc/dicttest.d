import std.stdio;
int[string] update(int[string] base){
	base["aa"] = base["aa"] + 1;
	return base;
}

void main(){
	auto base = ["aa" : 2];
	base.writeln;
	update(base);
	base.writeln;
	base = update(base);
	base.writeln;
	"hello".writeln;
}