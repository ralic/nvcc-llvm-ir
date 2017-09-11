.PHONY: test test1 test1_unopt test1_opt test2 test2_unopt test2_opt

all: libcicc.so libnvcc.so

libcicc.so: cicc.cpp
	mpic++ -g -D__STDC_LIMIT_MACROS -D__STDC_CONSTANT_MACROS  -I/usr/local/opt/llvm/include -I/usr/local/cuda/nvvm/include/ -I/usr/local/opt/llvm/include/llvm/IR/ -fPIC $< -shared -o $@ -ldl -L/usr/local/opt/llvm/lib -Wl,--start-group -lLLVMCore -lLLVMSupport -lLLVMipo -lLLVMipa -lLLVMAnalysis -lLLVMTarget -lLLVMScalarOpts -lLLVMTransformUtils -lLLVMInstCombine -Wl,--end-group -lpthread -I/usr/local/opt/python3/lib -L/usr/local/opt/lapack/lib -L/usr/local/opt/openblas/lib -L/usr/local/opt/llvm/lib

libnvcc.so: nvcc.cpp
	mpic++ -g -I /usr/local/cuda/nvvm/include/ -fPIC $< -shared -o $@ -ldl

clean:
	rm -rf libcicc.so libnvcc.so

test: test1 test2

test1: test1_unopt test1_opt

test1_unopt: libcicc.so libnvcc.so
	CICC_MODIFY_UNOPT_MODULE=1 LD_PRELOAD=./libnvcc.so nvcc -arch=sm_30 test1.cu -rdc=true -c -keep

test1_opt: libcicc.so libnvcc.so
	CICC_MODIFY_OPT_MODULE=1 LD_PRELOAD=./libnvcc.so nvcc -arch=sm_30 test1.cu -rdc=true -c -keep

test2: test2_unopt test2_opt

test2_unopt: libcicc.so libnvcc.so
	CICC_MODIFY_UNOPT_MODULE=1 LD_PRELOAD=./libnvcc.so nvcc -arch=sm_30 test2.cu -rdc=true -c -keep

test2_opt: libcicc.so libnvcc.so
	CICC_MODIFY_OPT_MODULE=1 LD_PRELOAD=./libnvcc.so nvcc -arch=sm_30 test2.cu -rdc=true -c -keep

