module cache_totalmente_associativa(input solicitacao_anterior_de_escrita_na_cache,

    input [7:0] bloco_lido_da_memoria,
    input clock1,
	input Reset, //reseta dados da cache para dados padrão
	input [4:0] tag_input,
	input [7:0] bloco_a_ser_escrito_na_cache,
	input write, //0-lê  1-escreve

	output reg [7:0] bloco_lido_da_cache,
	output reg [7:0] bloco_a_ser_escrito_na_memoria,
	output reg [4:0] tag_de_acesso_na_memoria,
	output reg solicitacao_de_escrita_na_memoria,
	output reg solicitacao_de_leitura_na_memoria,
	output reg hit);

	reg[15:0] cache[1:0];

	/*
	>>>>> ESTRUTURA DA CACHE <<<<<<

	cache[?][15] - bit de validade
	cache[?][14:10] - tag da cache
	cache[?][9] - LRU de 1 bits
	cache[?][8] - bit de dirty
	cache[?][7:0] - bloco de memória
	*/

	reg acessado;
	wire [1:0] valid;
	wire [4:0] tag_cache[1:0];
	wire [1:0] lru;
	wire [1:0] dirty;
	wire [7:0] bloco_cache[1:0];

	assign valid[0] = cache[0][15];
	assign valid[1] = cache[0][15];

	assign tag_cache[0] = cache[0][14:10];
	assign tag_cache[1] = cache[1][14:10];

	assign lru[0] = cache[0][9];
	assign lru[1] = cache[1][9];

	assign dirty[0] = cache[0][8];
	assign dirty[1] = cache[1][8];

	assign bloco_cache[0] = cache[0][7:0];
	assign bloco_cache[1] = cache[1][7:0];

	always@(posedge clock1) begin

	solicitacao_de_escrita_na_memoria = 1'b0;
	solicitacao_de_leitura_na_memoria = 1'b0;
	//OPERACAO DE RESET
	if(Reset) begin
			solicitacao_de_leitura_na_memoria = 1'b0;

			//([15]bit de validade, [14:10]tag, [9]lru, [8]dirty, [0:7]valor)
			cache[0] = 16'b1001000000000101; //tag = 100, valor = 5
			cache[1] = 16'b1001011000000011; //tag = 101, valor = 3
	end

	//OPERACAO DE ESCRITA
	else if(write) begin
		if(valid[0]==0 && valid[1]==0) begin	//quando os dois blocos são inválidos
			acessado = 1'b0;
			hit=1'b0;
		end

		else begin 	//quando há um dos blocos validos
			if(tag_cache[0] == tag_input && valid[0] == 1) begin 	//quando acertamos a tag na chace[0]
				acessado = 1'b0;
				hit=1'b1;
			end

			else if(tag_cache[1] == tag_input && valid[1] == 1) begin //quando acertamos a tag na chache[1]
				acessado = 1'b1;
				hit=1'b1;
			end

			else begin 	//quando não contem o endereço(tag)
				hit=1'b0;

				if(lru[0] == 1'b0) begin	//caso o primeiro bloco seja o mais antigo (lru=0)
					acessado = 1'b0;
				end

				else begin	//caso o segundo bloco seja o mais antigo (lru=0)
					acessado = 1'b1;
				end

				if(dirty[acessado] == 1'b1) begin //caso as duas lru´s sejam iguais a 1
					solicitacao_de_escrita_na_memoria = 1'b1;
					bloco_a_ser_escrito_na_memoria = bloco_cache[acessado]; //atualizamos o bloco na memoria
					tag_de_acesso_na_memoria = tag_cache[acessado];			//atualizamso a tag na memoria
				end
			end
		end

		//sempre executa sobrescrevendo a tag e o bloco, atualizando a lru´s
		cache[acessado] = {1'b1,tag_input,1'b1,1'b1,bloco_a_ser_escrito_na_cache};
		cache[~acessado][9] = 1'b0;
	end


	//OPERACAO DE LEITURA
	else begin
		if(valid[0]==0 && valid[1]==0) begin	//caso a leitura seja em blocos invalidos
			hit=1'b0;
			acessado = 1'b0;
			solicitacao_de_leitura_na_memoria = 1'b1;			//solicitamos a leitura na memoria
			tag_de_acesso_na_memoria = tag_cache[acessado]; 	//trazemos a tag da memoria
			cache[acessado][15] = 1'b1;							//atualizamos o valid
			cache[acessado][8] = 1'b0; 							//atualizamos o dirty
		end

		else begin
			if(tag_cache[0] == tag_input && valid[0] == 1) begin 	//caso contenha a tag requisitada na chace[0]
				acessado = 1'b0;
				bloco_lido_da_cache = bloco_cache[acessado]; 		//apenas realizamos a leitura
				hit=1'b1;
			end

			else if(tag_cache[1] == tag_input && valid[1] == 1) begin //caso contenha a tag requisitada na chace[1]
				acessado = 1'b1;
				bloco_lido_da_cache = bloco_cache[acessado];		//realizamos a leitura
				hit=1'b1;
			end

			else begin	//caso nao contem a tag requisitada em nenhum dos blocos da cache
				hit=1'b0;
				if(lru[0] == 1'b0) begin	//lru[0] = 0, dado mais antigo pra ser substituido
					acessado = 1'b0;
				end
				else begin	//lru[0] != 0 (sendo lru[1]=0 ou lru[1]=1, nao importa), dado mais antigo pra ser substituido
					acessado = 1'b1;
				end

				if(dirty[acessado] == 1'b1) begin 	//caso od dois blocos tenham lru = 1 ???
					tag_de_acesso_na_memoria = tag_cache[acessado];
					solicitacao_de_escrita_na_memoria = 1'b1;
					bloco_a_ser_escrito_na_memoria = bloco_cache[acessado];
					cache[acessado][15] = 1'b1;
					cache[acessado][8] = 1'b0;
				end

				//executamos sempre no caso de nao conter a tag desejada na cahce
				solicitacao_de_leitura_na_memoria = 1'b1; 			//solicitamos leitura na mem
				tag_de_acesso_na_memoria = tag_cache[acessado]; 	//trazemos a tag da mem
				cache[acessado][15] = 1'b1;							//atualizamos o bit valido
				cache[acessado][8] = 1'b0; 							//atualizamos o bit dirty
			end

		end

		//toda leitura atualiza a lru
		cache[acessado][9] = 1'b1;
		cache[~acessado][9] = 1'b0;
		end
	end
	endmodule


module decod7_1(cin, cout);//transformar o binario em hexadecimal
	input [3:0]cin;
	output reg [0:6]cout;

	always @(cin)
	begin
		case(cin)  //abcdefg
		0: cout = 	7'b0000001;
		1: cout = 	7'b1001111;
		2: cout = 	7'b0010010;
		3: cout = 	7'b0000110;
		4: cout = 	7'b1001100;
		5: cout = 	7'b0100100;
		6: cout = 	7'b0100000;
		7: cout = 	7'b0001111;
		8: cout = 	7'b0000000;
		9: cout = 	7'b0000100;
		10: cout = 	7'b0001000; //A
		11: cout = 	7'b1100000; //B
		12: cout = 	7'b0110001; //C
		13: cout = 	7'b1000010; //D
		14: cout = 	7'b0110000; //E
		15: cout = 	7'b0111000; //F
		default : cout = 0;
		endcase
	end

endmodule

module parte_3 (SW, LEDR, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7, KEY);

	input [17:0]SW;
	input [1:0] KEY;
	output [0:6] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7;
	output [17:0] LEDR;

	reg solicitacao_anterior_de_escrita_na_cache;
	wire [7:0] bloco_lido_da_memoria;
	wire clock1 = KEY[0];
	wire reset = KEY[1]; 	//reseta dados da cache para dados padrão
	wire [4:0] tag_input = SW[14:10];
	wire [7:0] bloco_a_ser_escrito_na_cache = SW[7:0];
	wire write = SW[17]; 									//0-lê  1-escreve

	wire [7:0] bloco_lido_da_cache;
	wire [7:0] bloco_a_ser_escrito_na_memoria;
	wire [4:0] tag_de_acesso_na_memoria;
	wire solicitacao_de_escrita_na_memoria;
	wire solicitacao_de_leitura_na_memoria;
	wire hit;

	reg clock2;

	cache_totalmente_associativa L1 (solicitacao_anterior_de_escrita_na_cache,
	                                 bloco_lido_da_memoria,
												clock1,
												reset,
												tag_input,
												bloco_a_ser_escrito_na_cache,
												write,
												bloco_lido_da_cache,
												bloco_a_ser_escrito_na_memoria,
												tag_de_acesso_na_memoria,
												solicitacao_de_escrita_na_memoria,
												solicitacao_de_leitura_na_memoria,
												hit);

	ramlpm MB1 (tag_de_acesso_na_memoria, bloco_a_ser_escrito_na_memoria, clock2, solicitacao_de_escrita_na_memoria , bloco_lido_da_memoria);

	wire [4:0] exibir_endereco;
	wire [7:0] exibir_bloco;

	assign exibir_endereco[0] = tag_input[0];
	assign exibir_endereco[1] = tag_input[1];
	assign exibir_endereco[2] = tag_input[2];
	assign exibir_endereco[3] = tag_input[3];
	assign exibir_endereco[4] = tag_input[4];

   assign exibir_bloco[0] = (bloco_lido_da_memoria[0] & solicitacao_de_leitura_na_memoria) | (bloco_lido_da_cache[0] & ~solicitacao_de_leitura_na_memoria);
	assign exibir_bloco[1] = (bloco_lido_da_memoria[1] & solicitacao_de_leitura_na_memoria) | (bloco_lido_da_cache[1] & ~solicitacao_de_leitura_na_memoria);
	assign exibir_bloco[2] = (bloco_lido_da_memoria[2] & solicitacao_de_leitura_na_memoria) | (bloco_lido_da_cache[2] & ~solicitacao_de_leitura_na_memoria);
	assign exibir_bloco[3] = (bloco_lido_da_memoria[3] & solicitacao_de_leitura_na_memoria) | (bloco_lido_da_cache[3] & ~solicitacao_de_leitura_na_memoria);
	assign exibir_bloco[4] = (bloco_lido_da_memoria[4] & solicitacao_de_leitura_na_memoria) | (bloco_lido_da_cache[4] & ~solicitacao_de_leitura_na_memoria);
	assign exibir_bloco[5] = (bloco_lido_da_memoria[5] & solicitacao_de_leitura_na_memoria) | (bloco_lido_da_cache[5] & ~solicitacao_de_leitura_na_memoria);
	assign exibir_bloco[6] = (bloco_lido_da_memoria[6] & solicitacao_de_leitura_na_memoria) | (bloco_lido_da_cache[6] & ~solicitacao_de_leitura_na_memoria);
	assign exibir_bloco[7] = (bloco_lido_da_memoria[7] & solicitacao_de_leitura_na_memoria) | (bloco_lido_da_cache[7] & ~solicitacao_de_leitura_na_memoria);

	decod7_1 d0 (exibir_endereco[3:0], HEX0);
	decod7_1 d1 ({3'b0,exibir_endereco[4]}, HEX1);
	decod7_1 d2 (exibir_bloco[3:0], HEX6);
	decod7_1 d3 (exibir_bloco[7:4], HEX7);

	assign LEDR[0] = hit;

	always@(posedge clock1) begin
		clock2 = ~clock2;
		if(solicitacao_de_leitura_na_memoria) begin
			solicitacao_anterior_de_escrita_na_cache = 1'b1;
		end
		else begin
			solicitacao_anterior_de_escrita_na_cache = 1'b0;
		end
	end

endmodule
