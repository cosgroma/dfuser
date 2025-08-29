cd valgrind_output/
| grep valgrind
| grep valgrind | cut -d ' ' -f2-
| grep valgrind | cut -d ' ' -f3-
| grep valgrind | cut -d ' ' -f4-
| grep valgrind | cut -d ' ' -f4- | sort | uniq
| grep valgrind | cut -d ' ' -f4- | sort | uniq > valgrind_commands.sh
history | grep valgrind
la valgrind_output/
la valgrind_output/callgrind_output/
la valgrind_output/massif_output/
mkdir valgrind_output
mv callgrind* valgrind_output/callgrind_output/
mv massif* valgrind_output/massif_output/
mv ms* valgrind_output/massif_output/
mv valgrind.igem_linux.05102021.txt valgrind_output/
mv xtreeleak.out.igem_linux.30092021 valgrind_output/
valgrind ./runtime/linux/bin
valgrind ./runtime/linux/bin/igem-0.1
valgrind ./runtime/linux/bin/igem-0.1 
valgrind ./runtime/linux/bin/igem-0.1 > valgrind.igem_linux.05102021.txt
valgrind --tool=callgrind --collect-systime=yes --callgrind-out-file=callgrind.out.igem_linux.28092021 ./runtime/linux/bin/igem-0.1
valgrind --tool=callgrind --collect-systime=yes --callgrind-out-file=callgrind.out.igem_linux.no_dynam_100 ./runtime/linux/bin/igem-0.1
valgrind --tool=callgrind --collect-systime=yes --callgrind-out-file=callgrind.out.igem_linux.no_dynam_1 ./runtime/linux/bin/igem-0.1
valgrind --tool=callgrind --collect-systime=yes --callgrind-out-file=callgrind.out.igem_linux.no_dynam_20 ./runtime/linux/bin/igem-0.1
valgrind --tool=callgrind --collect-systime=yes --callgrind-out-file=callgrind.out.igem_linux.no_dynam ./runtime/linux/bin/igem-0.1
valgrind --tool=callgrind ./runtime/linux/bin/igem-0.1 
valgrind --tool=massif --massif-out-file=massif.out.igem_linux.11102021 ./runtime/linux/bin/igem-0.1
valgrind --tool-massif --massif-out-file=massif.out.igem_linux.11102021 ./runtime/linux/bin/igem-0.1
valgrind --tool=massif --massif-out-file=massif.out.igem_linux.28092021 ./runtime/linux/bin/igem-0.1
valgrind --tool-massif --massif-out-file=massif.out.igem_linux.28092021 ./runtime/linux/bin/igem-0.1
valgrind --tool=massif --massif-out-file=massif.out.igem_linux.no_dynam ./runtime/linux/bin/igem-0.1
valgrind --tool=memcheck --xtree-leak=yes --xtree-leak-file=xtreeleak.out.igem_linux.30092021 ./runtime/linux/bin/igem-0.1
which valgrind
