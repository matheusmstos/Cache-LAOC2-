module conj_ass2vias()

	input clock;
	input [4:0] tag_input; //tag que vem da memoria pra associa rcom a tag da cache
	
	reg[15:0] conj1[1:0]; //Conjunto 1
	reg[15:0] conj2[1:0]; //Conjunto 2
	
	/* DECLARAÇÃO DO CONJUNTO 1 */
	
	reg acessado;
	wire [1:0] valid1;
	wire [4:0] tag_conj1[1:0];
	wire [1:0] lru1;
	wire [1:0] dirty1;
	wire [7:0] bloco_conj1[1:0];
	
	assign valid1[0] = conj1[0][15];
	assign valid1[1] = conj1[1][15];
	assign tag_conj1[0] = conj1[0][14:10];
	assign tag_conj1[1] = conj1[1][14:10];
	assign lru1[0] = conj1[0][9];
	assign lru1[1] = conj1[1][9];
	assign dirty1[0] = conj1[0][8];
	assign dirty1[1] = conj1[1][8];
	assign bloco_conj1[0] = conj1[0][7:0];
	assign bloco_conj1[1] = conj1[1][7:0];
	
	
	/* DECLARAÇÃO DO CONJUNTO 2 */
	
	wire [1:0] valid2;
	wire [4:0] tag_conj2[1:0];
	wire [1:0] lru2;
	wire [1:0] dirty2;
	wire [7:0] bloco_conj2[1:0];
	
	assign valid2[0] = conj2[0][15];
	assign valid2[1] = conj2[1][15];
	assign tag_conj2[0] = conj2[0][14:10];
	assign tag_conj2[1] = conj2[1][14:10];
	assign lru2[0] = conj2[0][9];
	assign lru2[1] = conj2[1][9];
	assign dirty2[0] = conj2[0][8];
	assign dirty2[1] = conj2[1][8];
	assign bloco_conj2[0] = conj2[0][7:0];
	assign bloco_conj2[1] = conj2[1][7:0];
	
	initial begin 
	
		/* INICIALIZAÇÃO DOS CONJUNTOS */
	
		//([15]bit de validade, [14:10]tag, [9]lru, [8]dirty, [0:7]valor)
		conj1[0] = 16'b1 00100 0000000000; //tag = 100, valor = 0
		conj1[1] = 16'b1 00101 1000000001; //tag = 101, valor = 1
		
		conj2[0] = 16'b1 00100 0000000010; //tag = 100, valor = 2
		conj2[1] = 16'b1 00101 1000000011; //tag = 101, valor = 3
		
		solicitacao_de_escrita_na_memoria = 1'b0;
		solicitacao_de_leitura_na_memoria = 1'b0;
		
	end
	
	always@(posedge clock) begin
		if(write) begin
			if (tag_conj1[0] == tag_input) begin //referenciua pro conjunto 1
				
				// implementa a parte conj 1
			
			end 
			else begin //caso nao seja o comj 1, automaticamente eh o 2
				
				// implementa a parte conj 2
			
			end
			
		
	
	
	
		

