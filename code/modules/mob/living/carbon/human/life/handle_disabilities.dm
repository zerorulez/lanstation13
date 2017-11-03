//Refer to life.dm for caller

/mob/living/carbon/human/proc/handle_disabilities()
	if(disabilities & EPILEPSY)
		if((prob(1)) && (paralysis < 1))
			visible_message("<span class='danger'>[src.name] começa a ter um ataque epiléptico!</span>", \
							"<span class='warning'>Você tem um ataque epiléptico!</span>")
			Paralyse(10)
			Jitter(1000) //Godness

	//If we have the gene for being crazy, have random events.
	if(dna.GetSEState(HALLUCINATIONBLOCK))
		if(prob(1) && hallucination < 1)
			hallucination += 20

	if(disabilities & COUGHING)
		if((prob(5) && paralysis <= 1))
			drop_item()
			audible_cough(src)
	if(disabilities & TOURETTES)
		if((prob(10) && paralysis <= 1))
			//Stun(10)
			switch(rand(1, 9))
				if(1)
					emote("twitch")
				if(2 to 9)
					say("[prob(50) ? ";" : ""][pick("MERDA", "BOSTA", "PUTA QUE PARIU", "FILHO DA PUTA", "SUGADOR DE CARALHOS", "PORRA", "BUCETA", "CORNO", "QUEIJIM MINAS", "CU", "EU QUERO É FUDER", "MERDALHER", "VAGABUNDA", "COMPLETAMENTE RIVOTRILADO", "CUCKOLD", "CORNO", "NEGRO")]")

			var/x_offset_change = rand(-2,2) * PIXEL_MULTIPLIER
			var/y_offset_change = rand(-1,1) * PIXEL_MULTIPLIER

			animate(src, pixel_x = (pixel_x + x_offset_change), pixel_y = (pixel_y + y_offset_change), time = 1)
			animate(pixel_x = (pixel_x - x_offset_change), pixel_y = (pixel_y - y_offset_change), time = 1)

	if(getBrainLoss() >= 60 && stat != DEAD)
		if(prob(3))
			switch(pick(1,2,3)) //All of those REALLY ought to be variable lists, but that would be too smart I guess
				if(1)
					say(pick("haha, esquece, eu gosto de chupar pintos", \
					"se a terra eh uma esfera por que a agua naum cai?", \
					"O CAPITÃO É UM PRESERVATIVO", "[pick("", "manda chamar o viado do")] [pick("somelia", "milha", "mirolha", "esmeralha")]", \
					"alguém mim dá [pick("telikesis","huque","epilapsia", "choquito")]?", \
					"me vê 2 kilos de muçarela, por favor", "bis são os melhores de todos os mundos>", \
					"macaquinho bonitinho", "NÃO TOCA EM MIM!!!!", \
					"SAI DAQUI CARALHO REEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE"))
				if(2)
					say(pick("EMERSON EDUARDO RODRIGUES SETIM MATOU ROGÉRIO GASPAR!!", \
						"VOCÊS NÃO CONSEGUEM PENETRAR MEU PROLAPSO TÃO RÁPIDO QUANTO EU GOSTARIA!", \
						"minha cara quando", \
						"deixem o macaco em paz", \
						"esses anões viu, sei não", \
						"mija aí que eu tomo aqui", \
						"acalmisi respiri fundo", \
						"to trancado", \
						"ei vei advinha vou sair daqui", \
						"quando eu sai vou pegar essa arma e te mata", \
						"temos tres peçoas na area de evacuassaum", \
						"ta vendo ces sao tudo racista", \
						"seus bando de doente", \
						"me fas o remedio de selebro", \
						"cresça criança", \
						"sou inteligente demais para trabalhar", \
						"voce nao eh durão ne", \
						"FINALMENTE PUTARIA!", \
						"DIMENSION", \
						"o quêêêêê?????", \
						"fiquei com medo deles e de você", \
						"estamos sem material sirurgíco , e vamos ter que ir na medbay comprar", \
						"qualquer coisa vc me liga ou manda um email (dr_nettoh@homail.com) fone: xxxx.xxxx", \
						"o que vc esta dizendo porraaaaa", \
						"meu deusssss", \
						"Por favor nao tire a vida dos seus filho(a) Dê a chance deles viver como vc teve a sua.", \
						"comotira as augemas", \
						"prendi o sapato", \
						"pelo amor de deus alguém chama a segurança", \
						"alguma coisa ta destruindo a nave", \
						"alguei mudou meu nome era ezequielBR agora e getulho vargas", \
						"Estou te robustando"))
				if(3)
					emote("drool")

	if(species.name == "Tajaran")
		if(prob(1)) //Was 3
			vomit(1) //Hairball

	if(stat != DEAD)
		var/rn = rand(0, 200) //This is fucking retarded, but I'm only doing sanitization, I don't have three months to spare to fix everything
		if(getBrainLoss() >= 5)
			if(0 <= rn && rn <= 3)
				custom_pain("Você sente fortes dores de cabeça.")
		if(getBrainLoss() >= 15)
			if(4 <= rn && rn <= 6)
				if(eye_blurry <= 0)
					to_chat(src, "<span class='warning'>Você tem dificuldades para enxergar.</span>")
					eye_blurry = 10
		if(getBrainLoss() >= 35)
			if(7 <= rn && rn <= 9)
				if(get_active_hand())
					to_chat(src, "<span class='warning'>Você não sente sua mão e acaba derrubando o que estava segurando.</span>")
					drop_item()
		if(getBrainLoss() >= 50)
			if(10 <= rn && rn <= 12)
				if(canmove)
					to_chat(src, "<span class='warning'>Você não sente suas pernas e acaba caindo.</span>")
					Knockdown(3)
