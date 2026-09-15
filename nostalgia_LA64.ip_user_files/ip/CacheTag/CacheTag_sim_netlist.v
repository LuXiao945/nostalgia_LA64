// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2025.1 (win64) Build 6140274 Thu May 22 00:12:29 MDT 2025
// Date        : Wed Jul  8 18:36:39 2026
// Host        : DESKTOP-HOBA6OQ running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim
//               E:/exe/vivado/project/nostalgia_LA64/nostalgia_LA64.runs/CacheTag_synth_1/CacheTag_sim_netlist.v
// Design      : CacheTag
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7z010clg400-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "CacheTag,blk_mem_gen_v8_4_11,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_11,Vivado 2025.1" *) 
(* NotValidForBitStream *)
module CacheTag
   (clka,
    wea,
    addra,
    dina,
    douta);
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA CLK" *) (* x_interface_mode = "slave BRAM_PORTA" *) (* x_interface_parameter = "XIL_INTERFACENAME BRAM_PORTA, MEM_ADDRESS_MODE BYTE_ADDRESS, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE OTHER, READ_LATENCY 1" *) input clka;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA WE" *) input [0:0]wea;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA ADDR" *) input [5:0]addra;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DIN" *) input [40:0]dina;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DOUT" *) output [40:0]douta;

  wire [5:0]addra;
  wire clka;
  wire [40:0]dina;
  wire [40:0]douta;
  wire [0:0]wea;
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
  wire [40:0]NLW_U0_doutb_UNCONNECTED;
  wire [5:0]NLW_U0_rdaddrecc_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_bid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_bresp_UNCONNECTED;
  wire [5:0]NLW_U0_s_axi_rdaddrecc_UNCONNECTED;
  wire [40:0]NLW_U0_s_axi_rdata_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_rid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_rresp_UNCONNECTED;

  (* C_ADDRA_WIDTH = "6" *) 
  (* C_ADDRB_WIDTH = "6" *) 
  (* C_ALGORITHM = "1" *) 
  (* C_AXI_ID_WIDTH = "4" *) 
  (* C_AXI_SLAVE_TYPE = "0" *) 
  (* C_AXI_TYPE = "1" *) 
  (* C_BYTE_SIZE = "9" *) 
  (* C_COMMON_CLK = "0" *) 
  (* C_COUNT_18K_BRAM = "0" *) 
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
  (* C_EST_POWER_SUMMARY = "Estimated Power for IP     :     5.89095 mW" *) 
  (* C_FAMILY = "zynq" *) 
  (* C_HAS_AXI_ID = "0" *) 
  (* C_HAS_ENA = "0" *) 
  (* C_HAS_ENB = "0" *) 
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
  (* C_INIT_FILE = "CacheTag.mem" *) 
  (* C_INIT_FILE_NAME = "no_coe_file_loaded" *) 
  (* C_INTERFACE_TYPE = "0" *) 
  (* C_LOAD_INIT_FILE = "0" *) 
  (* C_MEM_TYPE = "0" *) 
  (* C_MUX_PIPELINE_STAGES = "0" *) 
  (* C_PRIM_TYPE = "1" *) 
  (* C_READ_DEPTH_A = "64" *) 
  (* C_READ_DEPTH_B = "64" *) 
  (* C_READ_LATENCY_A = "1" *) 
  (* C_READ_LATENCY_B = "1" *) 
  (* C_READ_WIDTH_A = "41" *) 
  (* C_READ_WIDTH_B = "41" *) 
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
  (* C_WRITE_DEPTH_A = "64" *) 
  (* C_WRITE_DEPTH_B = "64" *) 
  (* C_WRITE_MODE_A = "WRITE_FIRST" *) 
  (* C_WRITE_MODE_B = "WRITE_FIRST" *) 
  (* C_WRITE_WIDTH_A = "41" *) 
  (* C_WRITE_WIDTH_B = "41" *) 
  (* C_XDEVICEFAMILY = "zynq" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  (* is_du_within_envelope = "true" *) 
  CacheTag_blk_mem_gen_v8_4_11 U0
       (.addra(addra),
        .addrb({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .clka(clka),
        .clkb(1'b0),
        .dbiterr(NLW_U0_dbiterr_UNCONNECTED),
        .deepsleep(1'b0),
        .dina(dina),
        .dinb({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .douta(douta),
        .doutb(NLW_U0_doutb_UNCONNECTED[40:0]),
        .eccpipece(1'b0),
        .ena(1'b0),
        .enb(1'b0),
        .injectdbiterr(1'b0),
        .injectsbiterr(1'b0),
        .rdaddrecc(NLW_U0_rdaddrecc_UNCONNECTED[5:0]),
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
        .s_axi_rdaddrecc(NLW_U0_s_axi_rdaddrecc_UNCONNECTED[5:0]),
        .s_axi_rdata(NLW_U0_s_axi_rdata_UNCONNECTED[40:0]),
        .s_axi_rid(NLW_U0_s_axi_rid_UNCONNECTED[3:0]),
        .s_axi_rlast(NLW_U0_s_axi_rlast_UNCONNECTED),
        .s_axi_rready(1'b0),
        .s_axi_rresp(NLW_U0_s_axi_rresp_UNCONNECTED[1:0]),
        .s_axi_rvalid(NLW_U0_s_axi_rvalid_UNCONNECTED),
        .s_axi_sbiterr(NLW_U0_s_axi_sbiterr_UNCONNECTED),
        .s_axi_wdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_wlast(1'b0),
        .s_axi_wready(NLW_U0_s_axi_wready_UNCONNECTED),
        .s_axi_wstrb(1'b0),
        .s_axi_wvalid(1'b0),
        .sbiterr(NLW_U0_sbiterr_UNCONNECTED),
        .shutdown(1'b0),
        .sleep(1'b0),
        .wea(wea),
        .web(1'b0));
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
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 30768)
`pragma protect data_block
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
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
