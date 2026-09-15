// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2025.1 (win64) Build 6140274 Thu May 22 00:12:29 MDT 2025
// Date        : Wed Jul  1 13:42:54 2026
// Host        : DESKTOP-HOBA6OQ running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim
//               E:/exe/vivado/project/nostalgia_LA64/nostalgia_LA64.runs/STLB_DATA_synth_1/STLB_DATA_sim_netlist.v
// Design      : STLB_DATA
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7z010clg400-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "STLB_DATA,blk_mem_gen_v8_4_11,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_11,Vivado 2025.1" *) 
(* NotValidForBitStream *)
module STLB_DATA
   (clka,
    wea,
    addra,
    dina,
    douta,
    clkb,
    enb,
    web,
    addrb,
    dinb,
    doutb);
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA CLK" *) (* x_interface_mode = "slave BRAM_PORTA" *) (* x_interface_parameter = "XIL_INTERFACENAME BRAM_PORTA, MEM_ADDRESS_MODE BYTE_ADDRESS, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE OTHER, READ_LATENCY 1" *) input clka;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA WE" *) input [0:0]wea;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA ADDR" *) input [3:0]addra;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DIN" *) input [63:0]dina;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DOUT" *) output [63:0]douta;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB CLK" *) (* x_interface_mode = "slave BRAM_PORTB" *) (* x_interface_parameter = "XIL_INTERFACENAME BRAM_PORTB, MEM_ADDRESS_MODE BYTE_ADDRESS, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE OTHER, READ_LATENCY 1" *) input clkb;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB EN" *) input enb;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB WE" *) input [0:0]web;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB ADDR" *) input [3:0]addrb;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB DIN" *) input [63:0]dinb;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB DOUT" *) output [63:0]doutb;

  wire [3:0]addra;
  wire [3:0]addrb;
  wire clka;
  wire [63:0]dina;
  wire [63:0]dinb;
  wire [63:0]douta;
  wire [63:0]doutb;
  wire enb;
  wire [0:0]wea;
  wire [0:0]web;
  wire NLW_U0_dbiterr_UNCONNECTED;
  wire NLW_U0_rsta_busy_UNCONNECTED;
  wire NLW_U0_rstb_busy_UNCONNECTED;
  wire NLW_U0_s_axi_arready_UNCONNECTED;
  wire NLW_U0_s_axi_awready_UNCONNECTED;
  wire NLW_U0_s_axi_bvalid_UNCONNECTED;
  wire NLW_U0_s_axi_dbiterr_UNCONNECTED;
  wire NLW_U0_s_axi_rlast_UNCONNECTED;
  wire NLW_U0_s_axi_rvalid_UNCONNECTED;
  wire NLW_U0_s_axi_sbiterr_UNCONNECTED;
  wire NLW_U0_s_axi_wready_UNCONNECTED;
  wire NLW_U0_sbiterr_UNCONNECTED;
  wire [3:0]NLW_U0_rdaddrecc_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_bid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_bresp_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_rdaddrecc_UNCONNECTED;
  wire [63:0]NLW_U0_s_axi_rdata_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_rid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_rresp_UNCONNECTED;

  (* C_ADDRA_WIDTH = "4" *) 
  (* C_ADDRB_WIDTH = "4" *) 
  (* C_ALGORITHM = "1" *) 
  (* C_AXI_ID_WIDTH = "4" *) 
  (* C_AXI_SLAVE_TYPE = "0" *) 
  (* C_AXI_TYPE = "1" *) 
  (* C_BYTE_SIZE = "9" *) 
  (* C_COMMON_CLK = "1" *) 
  (* C_COUNT_18K_BRAM = "0" *) 
  (* C_COUNT_36K_BRAM = "2" *) 
  (* C_CTRL_ECC_ALGO = "NONE" *) 
  (* C_DEFAULT_DATA = "0" *) 
  (* C_DISABLE_WARN_BHV_COLL = "0" *) 
  (* C_DISABLE_WARN_BHV_RANGE = "0" *) 
  (* C_ELABORATION_DIR = "./" *) 
  (* C_ENABLE_32BIT_ADDRESS = "0" *) 
  (* C_EN_DEEPSLEEP_PIN = "0" *) 
  (* C_EN_ECC_PIPE = "0" *) 
  (* C_EN_RDADDRA_CHG = "0" *) 
  (* C_EN_RDADDRB_CHG = "0" *) 
  (* C_EN_SAFETY_CKT = "0" *) 
  (* C_EN_SHUTDOWN_PIN = "0" *) 
  (* C_EN_SLEEP_PIN = "0" *) 
  (* C_EST_POWER_SUMMARY = "Estimated Power for IP     :     11.8086 mW" *) 
  (* C_FAMILY = "zynq" *) 
  (* C_HAS_AXI_ID = "0" *) 
  (* C_HAS_ENA = "0" *) 
  (* C_HAS_ENB = "1" *) 
  (* C_HAS_INJECTERR = "0" *) 
  (* C_HAS_MEM_OUTPUT_REGS_A = "0" *) 
  (* C_HAS_MEM_OUTPUT_REGS_B = "0" *) 
  (* C_HAS_MUX_OUTPUT_REGS_A = "0" *) 
  (* C_HAS_MUX_OUTPUT_REGS_B = "0" *) 
  (* C_HAS_REGCEA = "0" *) 
  (* C_HAS_REGCEB = "0" *) 
  (* C_HAS_RSTA = "0" *) 
  (* C_HAS_RSTB = "0" *) 
  (* C_HAS_SOFTECC_INPUT_REGS_A = "0" *) 
  (* C_HAS_SOFTECC_OUTPUT_REGS_B = "0" *) 
  (* C_INITA_VAL = "0" *) 
  (* C_INITB_VAL = "0" *) 
  (* C_INIT_FILE = "STLB_DATA.mem" *) 
  (* C_INIT_FILE_NAME = "no_coe_file_loaded" *) 
  (* C_INTERFACE_TYPE = "0" *) 
  (* C_LOAD_INIT_FILE = "0" *) 
  (* C_MEM_TYPE = "2" *) 
  (* C_MUX_PIPELINE_STAGES = "0" *) 
  (* C_PRIM_TYPE = "1" *) 
  (* C_READ_DEPTH_A = "16" *) 
  (* C_READ_DEPTH_B = "16" *) 
  (* C_READ_LATENCY_A = "1" *) 
  (* C_READ_LATENCY_B = "1" *) 
  (* C_READ_WIDTH_A = "64" *) 
  (* C_READ_WIDTH_B = "64" *) 
  (* C_RSTRAM_A = "0" *) 
  (* C_RSTRAM_B = "0" *) 
  (* C_RST_PRIORITY_A = "CE" *) 
  (* C_RST_PRIORITY_B = "CE" *) 
  (* C_SIM_COLLISION_CHECK = "ALL" *) 
  (* C_USE_BRAM_BLOCK = "0" *) 
  (* C_USE_BYTE_WEA = "0" *) 
  (* C_USE_BYTE_WEB = "0" *) 
  (* C_USE_DEFAULT_DATA = "0" *) 
  (* C_USE_ECC = "0" *) 
  (* C_USE_SOFTECC = "0" *) 
  (* C_USE_URAM = "0" *) 
  (* C_WEA_WIDTH = "1" *) 
  (* C_WEB_WIDTH = "1" *) 
  (* C_WRITE_DEPTH_A = "16" *) 
  (* C_WRITE_DEPTH_B = "16" *) 
  (* C_WRITE_MODE_A = "WRITE_FIRST" *) 
  (* C_WRITE_MODE_B = "WRITE_FIRST" *) 
  (* C_WRITE_WIDTH_A = "64" *) 
  (* C_WRITE_WIDTH_B = "64" *) 
  (* C_XDEVICEFAMILY = "zynq" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  (* is_du_within_envelope = "true" *) 
  STLB_DATA_blk_mem_gen_v8_4_11 U0
       (.addra(addra),
        .addrb(addrb),
        .clka(clka),
        .clkb(1'b0),
        .dbiterr(NLW_U0_dbiterr_UNCONNECTED),
        .deepsleep(1'b0),
        .dina(dina),
        .dinb(dinb),
        .douta(douta),
        .doutb(doutb),
        .eccpipece(1'b0),
        .ena(1'b0),
        .enb(enb),
        .injectdbiterr(1'b0),
        .injectsbiterr(1'b0),
        .rdaddrecc(NLW_U0_rdaddrecc_UNCONNECTED[3:0]),
        .regcea(1'b1),
        .regceb(1'b1),
        .rsta(1'b0),
        .rsta_busy(NLW_U0_rsta_busy_UNCONNECTED),
        .rstb(1'b0),
        .rstb_busy(NLW_U0_rstb_busy_UNCONNECTED),
        .s_aclk(1'b0),
        .s_aresetn(1'b0),
        .s_axi_araddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arburst({1'b0,1'b0}),
        .s_axi_arid({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arlen({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arready(NLW_U0_s_axi_arready_UNCONNECTED),
        .s_axi_arsize({1'b0,1'b0,1'b0}),
        .s_axi_arvalid(1'b0),
        .s_axi_awaddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awburst({1'b0,1'b0}),
        .s_axi_awid({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awlen({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awready(NLW_U0_s_axi_awready_UNCONNECTED),
        .s_axi_awsize({1'b0,1'b0,1'b0}),
        .s_axi_awvalid(1'b0),
        .s_axi_bid(NLW_U0_s_axi_bid_UNCONNECTED[3:0]),
        .s_axi_bready(1'b0),
        .s_axi_bresp(NLW_U0_s_axi_bresp_UNCONNECTED[1:0]),
        .s_axi_bvalid(NLW_U0_s_axi_bvalid_UNCONNECTED),
        .s_axi_dbiterr(NLW_U0_s_axi_dbiterr_UNCONNECTED),
        .s_axi_injectdbiterr(1'b0),
        .s_axi_injectsbiterr(1'b0),
        .s_axi_rdaddrecc(NLW_U0_s_axi_rdaddrecc_UNCONNECTED[3:0]),
        .s_axi_rdata(NLW_U0_s_axi_rdata_UNCONNECTED[63:0]),
        .s_axi_rid(NLW_U0_s_axi_rid_UNCONNECTED[3:0]),
        .s_axi_rlast(NLW_U0_s_axi_rlast_UNCONNECTED),
        .s_axi_rready(1'b0),
        .s_axi_rresp(NLW_U0_s_axi_rresp_UNCONNECTED[1:0]),
        .s_axi_rvalid(NLW_U0_s_axi_rvalid_UNCONNECTED),
        .s_axi_sbiterr(NLW_U0_s_axi_sbiterr_UNCONNECTED),
        .s_axi_wdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_wlast(1'b0),
        .s_axi_wready(NLW_U0_s_axi_wready_UNCONNECTED),
        .s_axi_wstrb(1'b0),
        .s_axi_wvalid(1'b0),
        .sbiterr(NLW_U0_sbiterr_UNCONNECTED),
        .shutdown(1'b0),
        .sleep(1'b0),
        .wea(wea),
        .web(web));
endmodule
`pragma protect begin_protected
`pragma protect version = 1
`pragma protect encrypt_agent = "XILINX"
`pragma protect encrypt_agent_info = "Xilinx Encryption Tool 2025.1"
`pragma protect key_keyowner="Synopsys", key_keyname="SNPS-VCS-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
gydSV72FvW4hnoyUt6yZFJHfJqjRQWPUfYIuDKP0fpjrPOkLRbJGBr4Z9msYTvoIHRlYtXJ2YMY0
d1TIQb+FK4gKsTRru9wr397OxuFBsTRf4e+ZjpYZEdsnqYWcgMSzhN4yhPvO06GyZO15y/LKBxa8
3OKwxVlOLYXhv+sxdXg=

`pragma protect key_keyowner="Aldec", key_keyname="ALDEC15_001", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
WHB6Zbfa5Qi47krP9T4L8UnPOlr881dWx7UcYaZfNGIQQM0gadcoXbhucIpRaUuyOKxv6yhKveRN
h0l+N9+KX6rbZ6+TRhP9JAMuPhlpI7T42QtRv5zx9+m3ct5S0NMszbFaK8zeTAYra5BGP7BHmtkr
MpKfLK5sFyaTE/A7ACtAace9MwFTHDZdl9uUs4aY6KJlm6GaypKduiqkNugukJp5vlFPX/ZapJqG
KMtMhI6grhcuYb1FJrwRZ4jW7hs9HxddSdGLzsZ0HsBcO/qaCPTst+ZA0YIQfd5ULlFmPqq39FfO
p1P+2hEH2n+LycbMj5cn4Dxfqv2R8eucM78R3w==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VELOCE-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
SmAzQA1VEuJXtJi5vXa2Jg7YvRqAJs6PX9HTZ1YqrJw4VfonBW3726gJ81BjlizpMkcf/Uk5sFIK
aPedVhEs4xCIZylz7gXYDshtytOA/pXUID2qV9nXr8qfI+FydSADUF3ScYDZmlkclFqlZrGq6DQ7
da3lJAzt2h/iR+cczrA=

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VERIF-SIM-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
iAph5JWb/chMQpLPX1UoLjQDxN5l2I8McM/k2xN5wRht7HXoE6F5yV8luDjn3zkI6vnfUYo7BaI1
mogRRx+R3XcwxvhHr+lngh4+/YLVex1TFncl+kiUMAsu3M/FjFSiqGMVMdKTNLDqr35DuZJVyuiF
lTwXob/KkbQDJiJjBEoxbt+968rKRKRyJGcqIjm4mqRBdqMcgo3HOJFG74SFsWAQrxvXfBhdLSG3
OfoLfls9XDojBjp7G83k0h82g1eeWgBfydm/OcX9o48Pst93NvI4ua8WShZL8MCvRWYqWZrrjrWi
cfUjXAF5SDACjq1/OU6arz/Idz6/a7AP/jmexw==

`pragma protect key_keyowner="Real Intent", key_keyname="RI-RSA-KEY-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
BY49GZBxBT/gjZDPyaSWlti/sctckoR7jK6NuWdhnF9tiyNfVU7BqjjwxSnyMi0Uucv1BKHXC18h
8hQbFWnNtrq71ilURotXux7sssHlVJ2i1CsJWU18DOcBWxm2ai89uwvxDJh3TJkBJixB5KPvsDhL
lWOjTvZWPoR+Ixy+Tzo+U5Vx7z7SOakRwTrn3u7+c3vmCEBphE+HKeJExhBAoOEd0SXK5iwXaByW
D7Wb7zq6NNUmnCyaJ2BG9kGxLVsf+md7SlocuaFsYyaRZhwPyTucxIlz1tLYwcytKzx0ovoax3no
nYgzlzP/F0/PDWk9BqXgr/tuclc4EZYX0cf4ng==

`pragma protect key_keyowner="Xilinx", key_keyname="xilinxt_2025.1-2029.x", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
qGnCvL35qO7cbUEKCL50yDv1UvezcqBz601zctKop1954QlcjemzZWZHg1zJ00nJaToNdH2S8AKX
n8hNJvbQ+x5HEGL5DoSU9m5qjXd8xxocnZ0yzuZX/dGCT8kDn3gWJR2Gz13pT+w2LQUno1fX+MsC
ehgwvjBBT6GeYjdxHi+aybQUP9AblSxX/z3vh857SGCPohEWvghOgORCHAe45YD+ZWnL62FLxMM2
c+Ozq/Au/Q4q1Yzlzcfv8Mnsvg7OqOeEamQHbuYOfdkJUuYqOwsskEWW348u7FXtsf8m7P3pZyyz
IWyTDAW4igGguMPLHfbtK/twZx8ScJQmOKzglg==

`pragma protect key_keyowner="Metrics Technologies Inc.", key_keyname="DSim", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
Hz+6K8+wh5/fukU4ZWNDXGsq6hreSVCSPP67nA6kUz9Vpjy4TtTnOrrl1BWY0ivEC7Ldyw8VI60A
VO/WPlt409LdAZdMZGsEZ1JuTZ0m9LPcgu9CPCyoMECctmd8LHE+otY6etTmYABB9syY61rk2hrv
RgbcyT/HCK9TzWxSm+XMqvx2nvagCLkMDPh/JZv51fj2zcKaBPnxsz8rnDipaeo0fEyVRC3Y1F/V
U3RmXojBjIumPHSJkQ537dENJEIA0Ra65u8EM/+ItUn1bcryLcIbKy1xGadrHmHdHRUoRcAodO2C
B48bNVeL0VnGg8P9ACIB04lMNzn5p6A1tPOb4Q==

`pragma protect key_keyowner="Atrenta", key_keyname="ATR-SG-RSA-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=384)
`pragma protect key_block
YDpb+UeT0rJ543Q8wCo2xSS3gpVAT+JoStgBlV5IMjJoUOWkiOPn691FGChmDi3BTq5NxC73KHHR
1galACCjeTGq6cv+0Zc2Ocm1oobdrnSPHp7TMDr5Zle8FX6WywJCiGdoWBODggZSlbOASIK/PVfY
cZM2z60M6RSvzsi3TnYHiKYHpju8THVoSgRd6r31GcbiSy9TjjARERXan0OVc79jGuAg90mmDEEq
91eqmn6NZ9yLI2fgBjFUZbtFCpmJ8WGxOL1h39niWnRK3ZXnk8jcpnZUlxLbYTPO0Z3vVr1zrvcn
RVQloU0OLqg7M95zSs7NtX5Vzvb6jGbMehWV+WMMyxWmxL2XOwsAwPSeX2dI2r77pioY7X6VzH7f
/JxMAnq9udra3WGPsUkD1G0CvPkCC3zdxjpVaflY37ztX9UONhKtzMQa8lJc1IL8GhXRY3R9Lg2c
HIeXSGkpNNuFDqKT6Khe/6Casq+SjFJq+IH9IUtz6RUZTkbFb0Xhgm2P

`pragma protect key_keyowner="Cadence Design Systems.", key_keyname="CDS_RSA_KEY_VER_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
Q+63zFEYw/LeMgxa7g8g79GGvSyIKDKD8RvvC4DHDQuGObf6n9OGZX4e17v/E/+EDEwUhsWQHFDI
Lp/aH+6fNRmhu9BEWVjxq2WRrQSl4eQjfIaSOXu2dlYh3JjRJwiUp4LteVh8RFAf5t5sRQO4dRIK
x+h28yliSgibaWEAv5FaJQ1EFbNwmgedAaSYjgf2A3afBUcBh5Uy9VHbW/zRzdhhJdsVNBjZYcFy
CVLOcf1toCRp8J4U5FlnFMOzFegUbdXFQhq2VmIhPRxWjrfTk6iR4BcMEN9UMij/5IHRAeBdksyD
CqEKsyFxosbI5KVMRZ1Ln75Zipn0JdsGekHkxg==

`pragma protect key_keyowner="Synplicity", key_keyname="SYNP15_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
DPUa5DLPYRWvbPnX0U412yoWvvvHyuq43DrYmDJGTK0cR5U4U6th8icYgizC1/hUAEzt19kM/hVa
zZh7bXSWACYLpcfhPY8dRTVGDZVjpbkraw0ceBryLP7jc6Jt5JdNw88tZtZpprCB7nQ25lUL82Hf
WTwL1ZqgGIvtfHhxO0JF5L5ES5giedwQ6u5ffXG3UB6ELcpQD1NvpW5lAz4mfXyvVDCAPZN581TF
tlAy79iKbPKlJ2zFn1BS2cuRIHHe2JRxwPo+0n5VD5CXVgg+lCYxTnCxI8CdyFaTumbs4IfAKwVI
wSN/btbwDUhW9hAHWHIRo+BpdJ4qeGcTDPKtsA==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-PREC-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
mf5hcf6JE6yLm0jNCQnHMVmogjLlPz6re0FwG67yvOJ3FuEorru0emIeAKEwgOoxjUYNWvcM7QAH
/UEeB2EIdjLl6glPAUda0HjtaCU2rdncVdM8k6DSMBggc4yo18Qx5F+1TD/RoBgoo0jNkMdDy6wJ
JHjqlN+R01z3yYIMQ9f2z6ZaYncbBYEp4+YAb7g1D7CSMxP5cFRpQznRpYp0JwqJfT9CHzlKgdab
8B288NxeLM66iYodiTS+GSRGLGtDWXpz9yeiuiPe6kJxae2GJyHIMSfluO/0Slc3m24DQNdbojf8
jdc0G2UnrDe5mCUTfYiDmpOWTUJOdYo0FK0N2g==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 47904)
`pragma protect data_block
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
cL5YU7sGpCsppq7kB/dHyIPFWhdJb1ds
`pragma protect end_protected
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;
    parameter GRES_WIDTH = 10000;
    parameter GRES_START = 10000;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    wire GRESTORE;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;
    reg GRESTORE_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;
    assign (strong1, weak0) GRESTORE = GRESTORE_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

    initial begin 
	GRESTORE_int = 1'b0;
	#(GRES_START);
	GRESTORE_int = 1'b1;
	#(GRES_WIDTH);
	GRESTORE_int = 1'b0;
    end

endmodule
`endif
