UVM_HOME = /release/uvm/uvm-1.2/src
VCS = vcs -full64 -sverilog -ntb_opts uvm -override_timescale=1ns/1ns -debug_access+all +incdir+$(UVM_HOME) $(UVM_HOME)/uvm.sv

proj         = $(firstword $(wildcard $(ex)-*))
buildsubdir  = /home/xxx/uvm/builddir/${proj}
dump        ?= vpd 

ifdef test
  testplusarg = "+UVM_TESTNAME=${test}"
  testpath    = ${buildsubdir}/${test}
else
  testplusarg = 
  testpath    = ${buildsubdir}
endif

buildrun:
  mkdir -p ${buildsubdir}
  make build
  make run

build:
  @cd ${proj} && $(VCS) -Mdir=${buildsubdir} -o ${buildsubdir}/simv top_tb.sv dut.sv

run:
  mkdir -p ${testpath}
  make gen_ucli
ifeq ($(dump), dve)
  @cd ${buildsubdir} && ./simv -gui=dve ${testplusarg}
else
  @cd ${buildsubdir} && ./simv -ucli -do ucli.do ${testplusarg} +ntb_random_seed=8 > ${testpath}/testrun.log 2>&1
  gvim ${testpath}/testrun.log
end


#RUN SIM with USER COMMAND LINE INTERFACE
gen_ucli:
ifeq ($(dump), fsdb)
  @echo -e "fsdbDumpvars 0 /top_tb +all +fsdbfile+dump.fsdb \\n fsdbD umpSVA 0 /top_tb \\n run" >${testpath}/ucli.do
else
  @echo -e "dump -add top_tb -depth 0 -aggregates -scope "." \\n run" >${testpath}/ucli.do
endif

clean:
  @rm -rf  ${buildsubdir}

