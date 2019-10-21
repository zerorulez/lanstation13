mob/living/carbon/proc/dream()
	dreaming = 1
	var/list/dreams = list(
		"uma carteira de identidade", "uma garrafa", "um rosto familiar", "um tripulante", "uma caixa de ferramentas", "um oficial de segurança", "o capitão",
		"espaço profundo", "médico", "motor", "trator", "aliado", "escuridão", "luz", "um cientista", "um macaco",
		"um ente querido", "calor", "o sol", "um chapéu", "a lua", "um planeta", "plasma", "ar", "a área médica", "a bridge",
		"luzes intermitentes", "luz azul", "Nanotrasen", "cura", "poder", "respeito", "riquezas", "espaço", "felicidade", "orgulho",
		"água", "melão", "vôo", "ovos", "dinheiro", "tenente", "chefe de segurança", "cachaça", 
		"um diretor de pesquisa", "o detetive", "o diretor", "um membro dos assuntos internos",
		"um engenheiro de estação", "o zelador", "técnico atmosférico", "o intendente", "um técnico de carga", "o botânico",
		"um mineiro", "um psicólogo", "o químico", "o geneticista", "o virologista", "o roboticista", "o chef", "o barman",
		"o capelão", "o bibliotecário", "um rato", "uma praia", "o holodeck", "uma sala com fumaça", "o Ian", "o bar",
		"a chuva", "o núcleo da AI", "a estação de mineração", "a estação de pesquisa", "um copo de líquido estranho", "uma equipe", "um homem com um corte de cabelo ruim",
		"as luas de Júpiter", "uma antiga IA com defeito", "bork", "uma galinha", "uma supernova", "armários", "ninjas",
		"galinhas", "forno", "euforia", "um ser celestial", "peidar", "queima de ossos", "evaporação de carne", "mundos distantes", "esqueletos",
		"vozes em todos os lugares", "morte", "traidor", "aliados sombrios", "trevas", "uma catástrofe", "uma arma", "congelamento", "uma estação em ruínas", "fogos de plasma",
		"um laboratório abandonado", "O Sindicato", "sangue", "caindo", "chamas", "gelo", "o frio", "uma mesa de operações", "uma guerra", "homens vermelhos", "robôs com defeito",
		"uma nave cheia de aranhas", "sua mãe", "lascivo", "explosões", "ossos quebrados", "palhaços em todos os lugares", "feições", "um acidente",
		"um esqueleto", "uma diona", "um lugar abandonado", "o fim do mundo", "a trovoada", "uma nave cheia de palhaços mortos", "uma galinha com poderes divinos ",
		"um ônibus vermelho que atravessa o espaço",
		)
	spawn(0)
		for(var/i = rand(1,4),i > 0, i--)
			var/dream_image = pick(dreams)
			dreams -= dream_image
			to_chat(src, "<span class='notice'><i>... [dream_image] ...</i></span>")
			sleep(rand(40,70))
			if(paralysis <= 0)
				dreaming = 0
				return 0
		dreaming = 0
		return 1

mob/living/carbon/proc/handle_dreams()
	if(prob(5) && !dreaming)
		dream()

mob/living/carbon/var/dreaming = 0
