module conj_ass2vias( input clock,
							 input write; //0 = leitura 
							 input[4:0] tag_input, //tag que vem da memoria pra associa com a tag da cache
							 input index_input);
							 
							 
							 
							 
							 
							 
							 
							 
							 
							 
		
	reg[11:0] cache[1:0][1:0]; // conjunto x via/bloco
	
	//Mapeametno da cache
	//validade.  [11]
	//lru.       [10]
	//dirty.     [9]
	//tag.       [8:5] 
	//index.     [4] -> meh 
	//bloco.     [4:0] 
	
	
	wire valid[1:0];
	wire lru[1:0];
	wire dirty[1:0]
	wire [3:0] tag_cache[1:0];
	//wire index[1:0];
	wire [4:0] bloco_cache[1:0];
	
	assign valid[0] = 	 	cache[index_input][0][11];
	assign valid[1] = 	 	cache[index_input][1][11];
	assign lru[0] =  		cache[index_input][0][10];
	assign lru[1] = 		cache[index_input][1][10];
	assign dirty[0] = 	 	cache[index_input][0][9];
	assign dirty[1] = 	 	cache[index_input][1][9];
	assign tag_cache[0] = 	cache[index_input][0][8:5];
	assign tag_cache[1] = 	cache[index_input][1][8:5];
	//assign index[0] = 	cache[index_input][0][4];
	//assign index[1] = 	cache[index_input][1][4];
	assign bloco_cache[0] = cache[index_input][0][4:0];
	assign bloco_cache[1] = cache[index_input][1][4:0];
	
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
		if(write) begin
			if (tag_conj1[0] == tag_input) begin //referenciua pro conjunto 1
				
				// implementa a parte conj 1
			
			end 
			else begin //caso nao seja o comj 1, automaticamente eh o 2
				
				// implementa a parte conj 2
			
			end
			
		
	
	
	
		
