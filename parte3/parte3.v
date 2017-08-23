module conj_ass2vias( 
	input clock,
	input write; //0 = leitura 
	input [4:0]adress_input, //endereco que vem da mem
	input [3:0] bloco_lido_da_memoria,
	input [3:0] bloco_a_ser_escrito_na_cache,
							 
	output reg hit;
							 
	);
										 
		
	reg[11:0] cache[1:0][1:0]; // conjunto x via/bloco
	
	reg acessado;
	wire valid[1:0][1:0];
	wire lru[1:0][1:0];
	wire dirty[1:0][1:0];
	wire [3:0] tag_cache[1:0][1:0];
	wire [4:0] bloco_cache[1:0][1:0];
	
	//slit do endereco input que vem da memoria
	wire index_input;
	wire tag_input;
	assign index_input = adress_input[0];
	assign tag_input = adress_input[4:1];
	
	//Mapeametno da cache
	//validade.  [11]
	//lru.       [10]
	//dirty.     [9]
	//tag.       [8:5] 
	//bloco.     [4:0] 

	assign valid[index_input][0] = 		 cache[index_input][0][11];
	assign valid[index_input][1] = 		 cache[index_input][1][11];
	assign lru[index_input][0] =  		 cache[index_input][0][10];
	assign lru[index_input][1] = 			 cache[index_input][1][10];
	assign dirty[index_input][0] = 	    cache[index_input][0][9];
	assign dirty[index_input][1] = 		 cache[index_input][1][9];
	assign tag_cache[index_input][0] = 	 cache[index_input][0][8:5];
	assign tag_cache[index_input][1] = 	 cache[index_input][1][8:5];
	assign bloco_cache[index_input][0] = cache[index_input][0][4:0];
	assign bloco_cache[index_input][1] = cache[index_input][1][4:0];
	
	initial begin 
	
		//INICIALIZAÇÃO DOS CONJUNTOS 
	
		//([11]validade, [10]lru, [9]dirty, [8:5]tag, [4:0]bloco)
		cache[0][0] = 12'b 1 0 0 0000 00000; //tag = 0000 , valor = 00000(0)
		cache[0][1] = 12'b 1 0 0 0001 00001; //tag = 0000 , valor = 00001(1)
		
		cache[1][0] = 12'b 1 0 0 0010 00010; //tag = 0010 , valor = 00010(2)
		cache[1][1] = 12'b 1 0 0 0011 00011; //tag = 0011 , valor = 00011(3)
		
		//cache[index][via]
		
		solicitacao_de_escrita_na_memoria = 1'b0;
		solicitacao_de_leitura_na_memoria = 1'b0;
		
	end
	
	always@(posedge clock) begin
		//ESCRITA
		if(write) begin
			if (valid[index_input][0] == 0 && valid[index_input][1] == 0) begin //caso os dois blocos sejam invalidos
				acessado = 1'b0;		
				hit=1'b0;
								
			end 
			
		else begin 
			if(tag_cache[index_input][0] == tag_input && valid[index_input][0] == 1) begin //quando acertamos a tag no bloco 0
				acessado = 1'b0;
				hit=1'b1;
			
			end
			
			else if(tag_cache[index_input][1] == tag_input && valid[index_input][1] == 1) begin //quando acertamos a tag no bloco 1
				acessado = 1'b1;
				hit=1'b1;
				
			end
			
			else begin //quando nao bate a tag, vamos ter que sobrescrever e atualizar na mem
			
				
				
			
		
	
	
	
		
