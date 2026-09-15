// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2025.1 (win64) Build 6140274 Thu May 22 00:12:29 MDT 2025
// Date        : Tue Jun 16 23:42:21 2026
// Host        : DESKTOP-HOBA6OQ running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim -rename_top STLB_comparison -prefix
//               STLB_comparison_ STLB_comparison_sim_netlist.v
// Design      : STLB_comparison
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7z010clg400-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "STLB_comparison,blk_mem_gen_v8_4_11,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_11,Vivado 2025.1" *) 
(* NotValidForBitStream *)
module STLB_comparison
   (clka,
    wea,
    addra,
    dina,
    douta,
    clkb,
    web,
    addrb,
    dinb,
    doutb);
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA CLK" *) (* x_interface_mode = "slave BRAM_PORTA" *) (* x_interface_parameter = "XIL_INTERFACENAME BRAM_PORTA, MEM_ADDRESS_MODE BYTE_ADDRESS, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE OTHER, READ_LATENCY 1" *) input clka;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA WE" *) input [0:0]wea;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA ADDR" *) input [3:0]addra;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DIN" *) input [46:0]dina;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DOUT" *) output [46:0]douta;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB CLK" *) (* x_interface_mode = "slave BRAM_PORTB" *) (* x_interface_parameter = "XIL_INTERFACENAME BRAM_PORTB, MEM_ADDRESS_MODE BYTE_ADDRESS, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE OTHER, READ_LATENCY 1" *) input clkb;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB WE" *) input [0:0]web;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB ADDR" *) input [3:0]addrb;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB DIN" *) input [46:0]dinb;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB DOUT" *) output [46:0]doutb;

  wire [3:0]addra;
  wire [3:0]addrb;
  wire clka;
  wire [46:0]dina;
  wire [46:0]dinb;
  wire [46:0]douta;
  wire [46:0]doutb;
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
  wire [46:0]NLW_U0_s_axi_rdata_UNCONNECTED;
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
  (* C_COUNT_18K_BRAM = "1" *) 
  (* C_COUNT_36K_BRAM = "1" *) 
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
  (* C_EST_POWER_SUMMARY = "Estimated Power for IP     :     8.918 mW" *) 
  (* C_FAMILY = "zynq" *) 
  (* C_HAS_AXI_ID = "0" *) 
  (* C_HAS_ENA = "0" *) 
  (* C_HAS_ENB = "0" *) 
  (* C_HAS_INJECTERR = "0" *) 
  (* C_HAS_MEM_OUTPUT_REGS_A = "1" *) 
  (* C_HAS_MEM_OUTPUT_REGS_B = "1" *) 
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
  (* C_INIT_FILE = "STLB_comparison.mem" *) 
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
  (* C_READ_WIDTH_A = "47" *) 
  (* C_READ_WIDTH_B = "47" *) 
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
  (* C_WRITE_WIDTH_A = "47" *) 
  (* C_WRITE_WIDTH_B = "47" *) 
  (* C_XDEVICEFAMILY = "zynq" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  (* is_du_within_envelope = "true" *) 
  STLB_comparison_blk_mem_gen_v8_4_11 U0
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
        .enb(1'b0),
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
        .s_axi_rdata(NLW_U0_s_axi_rdata_UNCONNECTED[46:0]),
        .s_axi_rid(NLW_U0_s_axi_rid_UNCONNECTED[3:0]),
        .s_axi_rlast(NLW_U0_s_axi_rlast_UNCONNECTED),
        .s_axi_rready(1'b0),
        .s_axi_rresp(NLW_U0_s_axi_rresp_UNCONNECTED[1:0]),
        .s_axi_rvalid(NLW_U0_s_axi_rvalid_UNCONNECTED),
        .s_axi_sbiterr(NLW_U0_s_axi_sbiterr_UNCONNECTED),
        .s_axi_wdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
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
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 38592)
`pragma protect data_block
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
VsfQ
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
