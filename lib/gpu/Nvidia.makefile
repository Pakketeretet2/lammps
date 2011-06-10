# /* ----------------------------------------------------------------------   
#    LAMMPS - Large-scale Atomic/Molecular Massively Parallel Simulator       
#    http://lammps.sandia.gov, Sandia National Laboratories                   
#    Steve Plimpton, sjplimp@sandia.gov                                       
#                                                                             
#    Copyright (2003) Sandia Corporation.  Under the terms of Contract        
#    DE-AC04-94AL85000 with Sandia Corporation, the U.S. Government retains   
#    certain rights in this software.  This software is distributed under      
#    the GNU General Public License.                                          
#                                                                             
#    See the README file in the top-level LAMMPS directory.                   
# ------------------------------------------------------------------------- */
#                                                                             
# /* ----------------------------------------------------------------------   
#    Contributing authors: Mike Brown (ORNL), brownw@ornl.gov               
#                          Peng Wang (Nvidia), penwang@nvidia.com
#                          Inderaj Bains (NVIDIA), ibains@nvidia.com
#                          Paul Crozier (SNL), pscrozi@sandia.gov             
# ------------------------------------------------------------------------- */

CUDA  = $(NVCC) $(CUDA_INCLUDE) $(CUDA_OPTS) -Icudpp_mini $(CUDA_ARCH) \
             $(CUDA_PRECISION)
CUDR  = $(CUDR_CPP) $(CUDR_OPTS) $(CUDA_PRECISION) $(CUDA_INCLUDE) \
        -Icudpp_mini
CUDA_LINK = $(CUDA_LIB) -lcudart

GPU_LIB = $(LIB_DIR)/libgpu.a

# Headers for Geryon
UCL_H  = $(wildcard ./geryon/ucl*.h)
NVC_H  = $(wildcard ./geryon/nvc*.h) $(UCL_H)
NVD_H  = $(wildcard ./geryon/nvd*.h) $(UCL_H) nv_kernel_def.h
# Headers for Pair Stuff
PAIR_H  = pair_gpu_atom.h pair_gpu_ans.h pair_gpu_nbor_shared.h \
          pair_gpu_nbor.h pair_gpu_precision.h pair_gpu_device.h \
          pair_gpu_balance.h pppm.h

ALL_H = $(NVD_H) $(PAIR_H)

EXECS = $(BIN_DIR)/nvc_get_devices
CUDPP = $(OBJ_DIR)/cudpp.o $(OBJ_DIR)/cudpp_plan.o \
        $(OBJ_DIR)/cudpp_maximal_launch.o $(OBJ_DIR)/cudpp_plan_manager.o \
        $(OBJ_DIR)/radixsort_app.cu_o $(OBJ_DIR)/scan_app.cu_o
OBJS = $(OBJ_DIR)/pair_gpu_atom.o $(OBJ_DIR)/pair_gpu_ans.o \
       $(OBJ_DIR)/pair_gpu_nbor.o $(OBJ_DIR)/pair_gpu_nbor_shared.o \
       $(OBJ_DIR)/pair_gpu_device.o $(OBJ_DIR)/atomic_gpu_memory.o \
       $(OBJ_DIR)/charge_gpu_memory.o $(OBJ_DIR)/base_ellipsoid.o \
       $(OBJ_DIR)/pppm.o $(OBJ_DIR)/pppm_ext.o \
       $(OBJ_DIR)/gayberne.o $(OBJ_DIR)/gayberne_ext.o \
       $(OBJ_DIR)/re_squared.o $(OBJ_DIR)/re_squared_ext.o \
       $(OBJ_DIR)/lj.o $(OBJ_DIR)/lj_ext.o \
       $(OBJ_DIR)/lj96.o $(OBJ_DIR)/lj96_ext.o \
       $(OBJ_DIR)/lj_expand.o $(OBJ_DIR)/lj_expand_ext.o \
       $(OBJ_DIR)/lj_coul.o $(OBJ_DIR)/lj_coul_ext.o \
       $(OBJ_DIR)/lj_coul_long.o $(OBJ_DIR)/lj_coul_long_ext.o \
       $(OBJ_DIR)/lj_class2_long.o $(OBJ_DIR)/lj_class2_long_ext.o \
       $(OBJ_DIR)/morse.o $(OBJ_DIR)/morse_ext.o \
       $(OBJ_DIR)/charmm_long.o $(OBJ_DIR)/charmm_long_ext.o \
       $(OBJ_DIR)/cg_cmm.o $(OBJ_DIR)/cg_cmm_ext.o \
       $(OBJ_DIR)/cg_cmm_long.o $(OBJ_DIR)/cg_cmm_long_ext.o \
       $(OBJ_DIR)/cg_cmm_msm.o $(OBJ_DIR)/cg_cmm_msm_ext.o \
       $(CUDPP)
PTXS = $(OBJ_DIR)/pair_gpu_dev_kernel.ptx \
       $(OBJ_DIR)/pair_gpu_atom_kernel.ptx $(OBJ_DIR)/pair_gpu_atom_ptx.h \
       $(OBJ_DIR)/pair_gpu_nbor_kernel.ptx $(OBJ_DIR)/pair_gpu_nbor_ptx.h \
       $(OBJ_DIR)/pair_gpu_build_kernel.ptx $(OBJ_DIR)/pair_gpu_build_ptx.h \
       $(OBJ_DIR)/pppm_f_gpu_kernel.ptx $(OBJ_DIR)/pppm_f_gpu_ptx.h \
       $(OBJ_DIR)/pppm_d_gpu_kernel.ptx $(OBJ_DIR)/pppm_d_gpu_ptx.h \
       $(OBJ_DIR)/ellipsoid_nbor.ptx $(OBJ_DIR)/ellipsoid_nbor_ptx.h \
       $(OBJ_DIR)/gayberne.ptx $(OBJ_DIR)/gayberne_lj.ptx \
       $(OBJ_DIR)/gayberne_ptx.h $(OBJ_DIR)/re_squared.ptx \
       $(OBJ_DIR)/re_squared_lj.ptx $(OBJ_DIR)/re_squared_ptx.h \
       $(OBJ_DIR)/lj.ptx $(OBJ_DIR)/lj_ext_ptx.h \
       $(OBJ_DIR)/lj96.ptx $(OBJ_DIR)/lj96_ext_ptx.h \
       $(OBJ_DIR)/lj_expand.ptx $(OBJ_DIR)/lj_expand_ext_ptx.h \
       $(OBJ_DIR)/lj_coul.ptx $(OBJ_DIR)/lj_coul_ext_ptx.h \
       $(OBJ_DIR)/lj_coul_long.ptx $(OBJ_DIR)/lj_coul_long_ext_ptx.h \
       $(OBJ_DIR)/lj_class2_long.ptx $(OBJ_DIR)/lj_class2_long_ptx.h \
       $(OBJ_DIR)/morse.ptx $(OBJ_DIR)/morse_ext_ptx.h \
       $(OBJ_DIR)/charmm_long.ptx $(OBJ_DIR)/charmm_long_ext_ptx.h \
       $(OBJ_DIR)/cg_cmm.ptx $(OBJ_DIR)/cg_cmm_ext_ptx.h \
       $(OBJ_DIR)/cg_cmm_long.ptx $(OBJ_DIR)/cg_cmm_long_ext_ptx.h \
       $(OBJ_DIR)/cg_cmm_msm.ptx $(OBJ_DIR)/cg_cmm_msm_ext_ptx.h

all: $(GPU_LIB) $(EXECS)

$(OBJ_DIR)/cudpp.o: cudpp_mini/cudpp.cpp
	$(CUDR) -o $@ -c cudpp_mini/cudpp.cpp -Icudpp_mini

$(OBJ_DIR)/cudpp_plan.o: cudpp_mini/cudpp_plan.cpp
	$(CUDR) -o $@ -c cudpp_mini/cudpp_plan.cpp -Icudpp_mini

$(OBJ_DIR)/cudpp_maximal_launch.o: cudpp_mini/cudpp_maximal_launch.cpp
	$(CUDR) -o $@ -c cudpp_mini/cudpp_maximal_launch.cpp -Icudpp_mini

$(OBJ_DIR)/cudpp_plan_manager.o: cudpp_mini/cudpp_plan_manager.cpp
	$(CUDR) -o $@ -c cudpp_mini/cudpp_plan_manager.cpp -Icudpp_mini

$(OBJ_DIR)/radixsort_app.cu_o: cudpp_mini/radixsort_app.cu
	$(CUDA) -o $@ -c cudpp_mini/radixsort_app.cu

$(OBJ_DIR)/scan_app.cu_o: cudpp_mini/scan_app.cu
	$(CUDA) -o $@ -c cudpp_mini/scan_app.cu

$(OBJ_DIR)/pair_gpu_atom_kernel.ptx: pair_gpu_atom_kernel.cu
	$(CUDA) --ptx -DNV_KERNEL -o $@ pair_gpu_atom_kernel.cu

$(OBJ_DIR)/pair_gpu_atom_ptx.h: $(OBJ_DIR)/pair_gpu_atom_kernel.ptx
	$(BSH) ./geryon/file_to_cstr.sh $(OBJ_DIR)/pair_gpu_atom_kernel.ptx $(OBJ_DIR)/pair_gpu_atom_ptx.h

$(OBJ_DIR)/pair_gpu_atom.o: pair_gpu_atom.cpp pair_gpu_atom.h $(NVD_H) $(OBJ_DIR)/pair_gpu_atom_ptx.h
	$(CUDR) -o $@ -c pair_gpu_atom.cpp -I$(OBJ_DIR)

$(OBJ_DIR)/pair_gpu_ans.o: pair_gpu_ans.cpp pair_gpu_ans.h $(NVD_H)
	$(CUDR) -o $@ -c pair_gpu_ans.cpp -I$(OBJ_DIR)

$(OBJ_DIR)/pair_gpu_nbor_kernel.ptx: pair_gpu_nbor_kernel.cu
	$(CUDA) --ptx -DNV_KERNEL -o $@ pair_gpu_nbor_kernel.cu

$(OBJ_DIR)/pair_gpu_nbor_ptx.h: $(OBJ_DIR)/pair_gpu_nbor_kernel.ptx
	$(BSH) ./geryon/file_to_cstr.sh $(OBJ_DIR)/pair_gpu_nbor_kernel.ptx $(OBJ_DIR)/pair_gpu_nbor_ptx.h

$(OBJ_DIR)/pair_gpu_build_kernel.ptx: pair_gpu_build_kernel.cu
	$(CUDA) --ptx -DNV_KERNEL -o $@ pair_gpu_build_kernel.cu

$(OBJ_DIR)/pair_gpu_build_ptx.h: $(OBJ_DIR)/pair_gpu_build_kernel.ptx
	$(BSH) ./geryon/file_to_cstr.sh $(OBJ_DIR)/pair_gpu_build_kernel.ptx $(OBJ_DIR)/pair_gpu_build_ptx.h

$(OBJ_DIR)/pair_gpu_nbor_shared.o: pair_gpu_nbor_shared.cpp pair_gpu_nbor_shared.h $(OBJ_DIR)/pair_gpu_nbor_ptx.h $(OBJ_DIR)/pair_gpu_build_ptx.h $(NVD_H)
	$(CUDR) -o $@ -c pair_gpu_nbor_shared.cpp -I$(OBJ_DIR)

$(OBJ_DIR)/pair_gpu_nbor.o: pair_gpu_nbor.cpp pair_gpu_nbor.h pair_gpu_nbor_shared.h $(NVD_H)
	$(CUDR) -o $@ -c pair_gpu_nbor.cpp -I$(OBJ_DIR)

$(OBJ_DIR)/pair_gpu_dev_kernel.ptx: pair_gpu_dev_kernel.cu
	$(CUDA) --ptx -DNV_KERNEL -o $@ pair_gpu_dev_kernel.cu

$(OBJ_DIR)/pair_gpu_dev_ptx.h: $(OBJ_DIR)/pair_gpu_dev_kernel.ptx
	$(BSH) ./geryon/file_to_cstr.sh $(OBJ_DIR)/pair_gpu_dev_kernel.ptx $(OBJ_DIR)/pair_gpu_dev_ptx.h

$(OBJ_DIR)/pair_gpu_device.o: pair_gpu_device.cpp pair_gpu_device.h $(ALL_H) $(OBJ_DIR)/pair_gpu_dev_ptx.h
	$(CUDR) -o $@ -c pair_gpu_device.cpp -I$(OBJ_DIR)

$(OBJ_DIR)/atomic_gpu_memory.o: $(ALL_H) atomic_gpu_memory.h atomic_gpu_memory.cpp
	$(CUDR) -o $@ -c atomic_gpu_memory.cpp

$(OBJ_DIR)/charge_gpu_memory.o: $(ALL_H) charge_gpu_memory.h charge_gpu_memory.cpp
	$(CUDR) -o $@ -c charge_gpu_memory.cpp

$(OBJ_DIR)/base_ellipsoid.o: $(ALL_H) base_ellipsoid.h base_ellipsoid.cpp $(OBJ_DIR)/ellipsoid_nbor_ptx.h
	$(CUDR) -o $@ -c base_ellipsoid.cpp -I$(OBJ_DIR)

$(OBJ_DIR)/pppm_f_gpu_kernel.ptx: pppm.cu pair_gpu_precision.h
	$(CUDA) --ptx -DNV_KERNEL -Dgrdtyp=float -Dgrdtyp4=float4 -o $@ pppm.cu

$(OBJ_DIR)/pppm_f_gpu_ptx.h: $(OBJ_DIR)/pppm_f_gpu_kernel.ptx
	$(BSH) ./geryon/file_to_cstr.sh $(OBJ_DIR)/pppm_f_gpu_kernel.ptx $(OBJ_DIR)/pppm_f_gpu_ptx.h

$(OBJ_DIR)/pppm_d_gpu_kernel.ptx: pppm.cu pair_gpu_precision.h
	$(CUDA) --ptx -DNV_KERNEL -Dgrdtyp=double -Dgrdtyp4=double4 -o $@ pppm.cu

$(OBJ_DIR)/pppm_d_gpu_ptx.h: $(OBJ_DIR)/pppm_d_gpu_kernel.ptx
	$(BSH) ./geryon/file_to_cstr.sh $(OBJ_DIR)/pppm_d_gpu_kernel.ptx $(OBJ_DIR)/pppm_d_gpu_ptx.h

$(OBJ_DIR)/pppm.o: $(ALL_H) pppm.h pppm.cpp $(OBJ_DIR)/pppm_f_gpu_ptx.h $(OBJ_DIR)/pppm_d_gpu_ptx.h
	$(CUDR) -o $@ -c pppm.cpp -I$(OBJ_DIR)

$(OBJ_DIR)/pppm_ext.o: $(ALL_H) pppm.h pppm_ext.cpp
	$(CUDR) -o $@ -c pppm_ext.cpp -I$(OBJ_DIR)

$(OBJ_DIR)/ellipsoid_nbor.ptx: ellipsoid_nbor.cu pair_gpu_precision.h
	$(CUDA) --ptx -DNV_KERNEL -o $@ ellipsoid_nbor.cu

$(OBJ_DIR)/ellipsoid_nbor_ptx.h: $(OBJ_DIR)/ellipsoid_nbor.ptx
	$(BSH) ./geryon/file_to_cstr.sh $(OBJ_DIR)/ellipsoid_nbor.ptx $(OBJ_DIR)/ellipsoid_nbor_ptx.h

$(OBJ_DIR)/gayberne.ptx: gayberne.cu pair_gpu_precision.h ellipsoid_extra.h
	$(CUDA) --ptx -DNV_KERNEL -o $@ gayberne.cu

$(OBJ_DIR)/gayberne_lj.ptx: gayberne_lj.cu pair_gpu_precision.h ellipsoid_extra.h
	$(CUDA) --ptx -DNV_KERNEL -o $@ gayberne_lj.cu

$(OBJ_DIR)/gayberne_ptx.h: $(OBJ_DIR)/gayberne.ptx $(OBJ_DIR)/gayberne_lj.ptx
	$(BSH) ./geryon/file_to_cstr.sh $(OBJ_DIR)/gayberne.ptx $(OBJ_DIR)/gayberne_lj.ptx $(OBJ_DIR)/gayberne_ptx.h

$(OBJ_DIR)/gayberne.o: $(ALL_H) gayberne.h gayberne.cpp $(OBJ_DIR)/gayberne_ptx.h $(OBJ_DIR)/base_ellipsoid.o
	$(CUDR) -o $@ -c gayberne.cpp -I$(OBJ_DIR)

$(OBJ_DIR)/gayberne_ext.o: $(ALL_H) $(OBJ_DIR)/gayberne.o gayberne_ext.cpp
	$(CUDR) -o $@ -c gayberne_ext.cpp -I$(OBJ_DIR)

$(OBJ_DIR)/re_squared.ptx: re_squared.cu pair_gpu_precision.h ellipsoid_extra.h
	$(CUDA) --ptx -DNV_KERNEL -o $@ re_squared.cu

$(OBJ_DIR)/re_squared_lj.ptx: re_squared_lj.cu pair_gpu_precision.h ellipsoid_extra.h
	$(CUDA) --ptx -DNV_KERNEL -o $@ re_squared_lj.cu

$(OBJ_DIR)/re_squared_ptx.h: $(OBJ_DIR)/re_squared.ptx $(OBJ_DIR)/re_squared_lj.ptx
	$(BSH) ./geryon/file_to_cstr.sh $(OBJ_DIR)/re_squared.ptx $(OBJ_DIR)/re_squared_lj.ptx $(OBJ_DIR)/re_squared_ptx.h

$(OBJ_DIR)/re_squared.o: $(ALL_H) re_squared.h re_squared.cpp $(OBJ_DIR)/re_squared_ptx.h $(OBJ_DIR)/base_ellipsoid.o
	$(CUDR) -o $@ -c re_squared.cpp -I$(OBJ_DIR)

$(OBJ_DIR)/re_squared_ext.o: $(ALL_H) $(OBJ_DIR)/re_squared.o re_squared_ext.cpp
	$(CUDR) -o $@ -c re_squared_ext.cpp -I$(OBJ_DIR)

$(OBJ_DIR)/lj.ptx: lj.cu pair_gpu_precision.h
	$(CUDA) --ptx -DNV_KERNEL -o $@ lj.cu

$(OBJ_DIR)/lj_ext_ptx.h: $(OBJ_DIR)/lj.ptx $(OBJ_DIR)/lj.ptx
	$(BSH) ./geryon/file_to_cstr.sh $(OBJ_DIR)/lj.ptx $(OBJ_DIR)/lj_ext_ptx.h

$(OBJ_DIR)/lj.o: $(ALL_H) lj.h lj.cpp $(OBJ_DIR)/lj_ext_ptx.h $(OBJ_DIR)/atomic_gpu_memory.o
	$(CUDR) -o $@ -c lj.cpp -I$(OBJ_DIR)

$(OBJ_DIR)/lj_ext.o: $(ALL_H) lj.h lj_ext.cpp atomic_gpu_memory.h
	$(CUDR) -o $@ -c lj_ext.cpp -I$(OBJ_DIR)

$(OBJ_DIR)/lj_coul.ptx: lj_coul.cu pair_gpu_precision.h
	$(CUDA) --ptx -DNV_KERNEL -o $@ lj_coul.cu

$(OBJ_DIR)/lj_coul_ext_ptx.h: $(OBJ_DIR)/lj_coul.ptx $(OBJ_DIR)/lj_coul.ptx
	$(BSH) ./geryon/file_to_cstr.sh $(OBJ_DIR)/lj_coul.ptx $(OBJ_DIR)/lj_coul_ext_ptx.h

$(OBJ_DIR)/lj_coul.o: $(ALL_H) lj_coul.h lj_coul.cpp $(OBJ_DIR)/lj_coul_ext_ptx.h $(OBJ_DIR)/charge_gpu_memory.o
	$(CUDR) -o $@ -c lj_coul.cpp -I$(OBJ_DIR)

$(OBJ_DIR)/lj_coul_ext.o: $(ALL_H) lj_coul.h lj_coul_ext.cpp charge_gpu_memory.h
	$(CUDR) -o $@ -c lj_coul_ext.cpp -I$(OBJ_DIR)

$(OBJ_DIR)/lj_class2_long.ptx: lj_class2_long.cu pair_gpu_precision.h
	$(CUDA) --ptx -DNV_KERNEL -o $@ lj_class2_long.cu

$(OBJ_DIR)/lj_class2_long_ptx.h: $(OBJ_DIR)/lj_class2_long.ptx $(OBJ_DIR)/lj_class2_long.ptx
	$(BSH) ./geryon/file_to_cstr.sh $(OBJ_DIR)/lj_class2_long.ptx $(OBJ_DIR)/lj_class2_long_ptx.h

$(OBJ_DIR)/lj_class2_long.o: $(ALL_H) lj_class2_long.h lj_class2_long.cpp $(OBJ_DIR)/lj_class2_long_ptx.h $(OBJ_DIR)/charge_gpu_memory.o
	$(CUDR) -o $@ -c lj_class2_long.cpp -I$(OBJ_DIR)

$(OBJ_DIR)/lj_class2_long_ext.o: $(ALL_H) lj_class2_long.h lj_class2_long_ext.cpp charge_gpu_memory.h
	$(CUDR) -o $@ -c lj_class2_long_ext.cpp -I$(OBJ_DIR)

$(OBJ_DIR)/lj_coul_long.ptx: lj_coul_long.cu pair_gpu_precision.h
	$(CUDA) --ptx -DNV_KERNEL -o $@ lj_coul_long.cu

$(OBJ_DIR)/lj_coul_long_ext_ptx.h: $(OBJ_DIR)/lj_coul_long.ptx $(OBJ_DIR)/lj_coul_long.ptx
	$(BSH) ./geryon/file_to_cstr.sh $(OBJ_DIR)/lj_coul_long.ptx $(OBJ_DIR)/lj_coul_long_ext_ptx.h

$(OBJ_DIR)/lj_coul_long.o: $(ALL_H) lj_coul_long.h lj_coul_long.cpp $(OBJ_DIR)/lj_coul_long_ext_ptx.h $(OBJ_DIR)/charge_gpu_memory.o
	$(CUDR) -o $@ -c lj_coul_long.cpp -I$(OBJ_DIR)

$(OBJ_DIR)/lj_coul_long_ext.o: $(ALL_H) lj_coul_long.h lj_coul_long_ext.cpp charge_gpu_memory.h
	$(CUDR) -o $@ -c lj_coul_long_ext.cpp -I$(OBJ_DIR)

$(OBJ_DIR)/morse.ptx: morse.cu pair_gpu_precision.h
	$(CUDA) --ptx -DNV_KERNEL -o $@ morse.cu

$(OBJ_DIR)/morse_ext_ptx.h: $(OBJ_DIR)/morse.ptx $(OBJ_DIR)/morse.ptx
	$(BSH) ./geryon/file_to_cstr.sh $(OBJ_DIR)/morse.ptx $(OBJ_DIR)/morse_ext_ptx.h

$(OBJ_DIR)/morse.o: $(ALL_H) morse.h morse.cpp $(OBJ_DIR)/morse_ext_ptx.h $(OBJ_DIR)/atomic_gpu_memory.o
	$(CUDR) -o $@ -c morse.cpp -I$(OBJ_DIR)

$(OBJ_DIR)/morse_ext.o: $(ALL_H) morse.h morse_ext.cpp atomic_gpu_memory.h
	$(CUDR) -o $@ -c morse_ext.cpp -I$(OBJ_DIR)

$(OBJ_DIR)/charmm_long.ptx: charmm_long.cu pair_gpu_precision.h
	$(CUDA) --ptx -DNV_KERNEL -o $@ charmm_long.cu

$(OBJ_DIR)/charmm_long_ext_ptx.h: $(OBJ_DIR)/charmm_long.ptx $(OBJ_DIR)/charmm_long.ptx
	$(BSH) ./geryon/file_to_cstr.sh $(OBJ_DIR)/charmm_long.ptx $(OBJ_DIR)/charmm_long_ext_ptx.h

$(OBJ_DIR)/charmm_long.o: $(ALL_H) charmm_long.h charmm_long.cpp $(OBJ_DIR)/charmm_long_ext_ptx.h $(OBJ_DIR)/charge_gpu_memory.o
	$(CUDR) -o $@ -c charmm_long.cpp -I$(OBJ_DIR)

$(OBJ_DIR)/charmm_long_ext.o: $(ALL_H) charmm_long.h charmm_long_ext.cpp charge_gpu_memory.h
	$(CUDR) -o $@ -c charmm_long_ext.cpp -I$(OBJ_DIR)

$(OBJ_DIR)/lj96.ptx: lj96.cu pair_gpu_precision.h
	$(CUDA) --ptx -DNV_KERNEL -o $@ lj96.cu

$(OBJ_DIR)/lj96_ext_ptx.h: $(OBJ_DIR)/lj96.ptx $(OBJ_DIR)/lj96.ptx
	$(BSH) ./geryon/file_to_cstr.sh $(OBJ_DIR)/lj96.ptx $(OBJ_DIR)/lj96_ext_ptx.h

$(OBJ_DIR)/lj96.o: $(ALL_H) lj96.h lj96.cpp $(OBJ_DIR)/lj96_ext_ptx.h $(OBJ_DIR)/atomic_gpu_memory.o
	$(CUDR) -o $@ -c lj96.cpp -I$(OBJ_DIR)

$(OBJ_DIR)/lj96_ext.o: $(ALL_H) lj96.h lj96_ext.cpp atomic_gpu_memory.h
	$(CUDR) -o $@ -c lj96_ext.cpp -I$(OBJ_DIR)

$(OBJ_DIR)/lj_expand.ptx: lj_expand.cu pair_gpu_precision.h
	$(CUDA) --ptx -DNV_KERNEL -o $@ lj_expand.cu

$(OBJ_DIR)/lj_expand_ext_ptx.h: $(OBJ_DIR)/lj_expand.ptx $(OBJ_DIR)/lj_expand.ptx
	$(BSH) ./geryon/file_to_cstr.sh $(OBJ_DIR)/lj_expand.ptx $(OBJ_DIR)/lj_expand_ext_ptx.h

$(OBJ_DIR)/lj_expand.o: $(ALL_H) lj_expand.h lj_expand.cpp $(OBJ_DIR)/lj_expand_ext_ptx.h $(OBJ_DIR)/atomic_gpu_memory.o
	$(CUDR) -o $@ -c lj_expand.cpp -I$(OBJ_DIR)

$(OBJ_DIR)/lj_expand_ext.o: $(ALL_H) lj_expand.h lj_expand_ext.cpp atomic_gpu_memory.h
	$(CUDR) -o $@ -c lj_expand_ext.cpp -I$(OBJ_DIR)

$(OBJ_DIR)/cg_cmm.ptx: cg_cmm.cu pair_gpu_precision.h
	$(CUDA) --ptx -DNV_KERNEL -o $@ cg_cmm.cu

$(OBJ_DIR)/cg_cmm_ext_ptx.h: $(OBJ_DIR)/cg_cmm.ptx $(OBJ_DIR)/cg_cmm.ptx
	$(BSH) ./geryon/file_to_cstr.sh $(OBJ_DIR)/cg_cmm.ptx $(OBJ_DIR)/cg_cmm_ext_ptx.h

$(OBJ_DIR)/cg_cmm.o: $(ALL_H) cg_cmm.h cg_cmm.cpp $(OBJ_DIR)/cg_cmm_ext_ptx.h $(OBJ_DIR)/atomic_gpu_memory.o
	$(CUDR) -o $@ -c cg_cmm.cpp -I$(OBJ_DIR)

$(OBJ_DIR)/cg_cmm_ext.o: $(ALL_H) cg_cmm.h cg_cmm_ext.cpp atomic_gpu_memory.h
	$(CUDR) -o $@ -c cg_cmm_ext.cpp -I$(OBJ_DIR)

$(OBJ_DIR)/cg_cmm_long.ptx: cg_cmm_long.cu pair_gpu_precision.h
	$(CUDA) --ptx -DNV_KERNEL -o $@ cg_cmm_long.cu

$(OBJ_DIR)/cg_cmm_long_ext_ptx.h: $(OBJ_DIR)/cg_cmm_long.ptx $(OBJ_DIR)/cg_cmm_long.ptx
	$(BSH) ./geryon/file_to_cstr.sh $(OBJ_DIR)/cg_cmm_long.ptx $(OBJ_DIR)/cg_cmm_long_ext_ptx.h

$(OBJ_DIR)/cg_cmm_long.o: $(ALL_H) cg_cmm_long.h cg_cmm_long.cpp $(OBJ_DIR)/cg_cmm_long_ext_ptx.h $(OBJ_DIR)/atomic_gpu_memory.o
	$(CUDR) -o $@ -c cg_cmm_long.cpp -I$(OBJ_DIR)

$(OBJ_DIR)/cg_cmm_long_ext.o: $(ALL_H) cg_cmm_long.h cg_cmm_long_ext.cpp charge_gpu_memory.h
	$(CUDR) -o $@ -c cg_cmm_long_ext.cpp -I$(OBJ_DIR)

$(OBJ_DIR)/cg_cmm_msm.ptx: cg_cmm_msm.cu pair_gpu_precision.h
	$(CUDA) --ptx -DNV_KERNEL -o $@ cg_cmm_msm.cu

$(OBJ_DIR)/cg_cmm_msm_ext_ptx.h: $(OBJ_DIR)/cg_cmm_msm.ptx $(OBJ_DIR)/cg_cmm_msm.ptx
	$(BSH) ./geryon/file_to_cstr.sh $(OBJ_DIR)/cg_cmm_msm.ptx $(OBJ_DIR)/cg_cmm_msm_ext_ptx.h

$(OBJ_DIR)/cg_cmm_msm.o: $(ALL_H) cg_cmm_msm.h cg_cmm_msm.cpp $(OBJ_DIR)/cg_cmm_msm_ext_ptx.h $(OBJ_DIR)/atomic_gpu_memory.o
	$(CUDR) -o $@ -c cg_cmm_msm.cpp -I$(OBJ_DIR)

$(OBJ_DIR)/cg_cmm_msm_ext.o: $(ALL_H) cg_cmm_msm.h cg_cmm_msm_ext.cpp charge_gpu_memory.h
	$(CUDR) -o $@ -c cg_cmm_msm_ext.cpp -I$(OBJ_DIR)

$(BIN_DIR)/nvc_get_devices: ./geryon/ucl_get_devices.cpp $(NVC_H)
	$(CUDR) -o $@ ./geryon/ucl_get_devices.cpp -DUCL_CUDART $(CUDA_LINK) 

$(GPU_LIB): $(OBJS)
	$(AR) -crusv $(GPU_LIB) $(OBJS)

clean:
	rm -f $(EXECS) $(GPU_LIB) $(OBJS) $(PTXS) *.linkinfo

veryclean: clean
	rm -rf *~ *.linkinfo
