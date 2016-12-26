default:
	verilator -Wno-INITIALDLY -Wno-lint -Wno-MULTIDRIVEN -Wno-UNOPTFLAT -Wno-COMBDLY -cc -top-module map -trace map.sv --exe map.cpp
	make -j -C obj_dir/ -f Vmap.mk  Vmap
	obj_dir/Vmap

counter:
	verilator -Wno-INITIALDLY -Wno-lint -Wno-MULTIDRIVEN -Wno-UNOPTFLAT -Wno-COMBDLY -cc -top-module counter -trace counter.sv --exe counter.cpp
	make -j -C obj_dir/ -f Vcounter.mk  Vcounter
	obj_dir/Vcounter

