`timescale 1ns / 1ps

module ControlUnit(  // Gera sinais de controle para os diversos blocos do processador
    input [5:0] Op, 
    input [5:0] Funct,
    output reg MemtoReg, MemWrite, Branch, ALUSrc, RegDst, RegWrite, Jump,
    output reg [3:0] ALUControl
);

always @(*) begin
    // Defaults  // Evita que qualquer sinal fique com valor indefinido. Depois, o case (Op) define os sinais corretos conforme a instrução.

    MemtoReg = 0;
    MemWrite = 0;
    Branch = 0;
    ALUSrc = 0;
    RegDst = 0;
    RegWrite = 0;
    Jump = 0;
    ALUControl = 4'b0000;

    case (Op)
        6'b000000: begin // R-type
            RegDst = 1;
            RegWrite = 1;
            case (Funct)
                6'b100000: ALUControl = 4'b0010; // ADD
                6'b100010: ALUControl = 4'b0110; // SUB
                6'b100100: ALUControl = 4'b0000; // AND
                6'b100101: ALUControl = 4'b0001; // OR
                6'b101010: ALUControl = 4'b0111; // SLT
                default:   ALUControl = 4'b0000;
            endcase
        end
        6'b100011: begin // LW
            ALUSrc = 1;
            MemtoReg = 1;
            RegWrite = 1;
            ALUControl = 4'b0010;
        end
        6'b101011: begin // SW
            ALUSrc = 1;
            MemWrite = 1;
            ALUControl = 4'b0010;
        end
        6'b000100: begin // BEQ
            Branch = 1;
            ALUControl = 4'b0110;
        end
        6'b000010: begin // J
            Jump = 1;
        end
        6'b001000: begin // ADDI
            ALUSrc = 1;
            RegWrite = 1;
            ALUControl = 4'b0010;   // Esse módulo é quem traduz a instrução binária em sinais de controle que ativam/desativam partes do processador de forma correta.
        end
    endcase
end
endmodule
