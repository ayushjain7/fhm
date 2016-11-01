default:
	verilator -Wno-INITIALDLY -Wno-lint -Wno-MULTIDRIVEN -Wno-UNOPTFLAT -Wno-COMBDLY -cc -top-module map -trace map.sv --exe map.cpp
	make -j -C obj_dir/ -f Vmap.mk  Vmap
	obj_dir/Vmap

