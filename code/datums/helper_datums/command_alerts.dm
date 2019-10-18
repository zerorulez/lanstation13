/datum/command_alert
	var/name //Descriptive name - it's not shown to anybody, so feel free to make it OOC

	var/alert_title = "Comando Central" //Traduzido por Anaonimo, FrostBleidd, Stingray e zero
	var/message

	var/force_report = 0
	var/alert = 'sound/AI/commandreport.ogg'//sound
	var/noalert = 0

/datum/command_alert/proc/announce()
	command_alert(message, alert_title, force_report, alert, noalert)

//////BIOHAZARD

/datum/command_alert/biohazard_alert
	name = "Alerta de Risco Biológico"
	alert_title = "Alerta de Risco Biológico"
	noalert = 1
	force_report = 1

	var/level = 1

/datum/command_alert/biohazard_alert/announce()
	level = rand(4,7)
	message = "Confirmado surto de risco biológico nível [level] a bordo da [station_name()]. Toda a tripulação deve conter o surto."

	..()

	var/list/vox_sentence=list(
	'sound/AI/outbreak_before.ogg',
	outbreak_level_words[level],
	'sound/AI/outbreak_after.ogg',
	)

	for(var/word in vox_sentence)
		play_vox_sound(word,STATION_Z,null)

///////BIOHAZARD UPDATED

/datum/command_alert/biohazard_station_lockdown
	name = "Nível de Risco Biológico Atualizado - Estação Trancada"
	alert_title = "Diretiva 7-10 Iniciada"
	alert = 'sound/AI/blob_confirmed.ogg'
	force_report = 1

/datum/command_alert/biohazard_station_lockdown/announce()
	message = "Alerta de surto de risco biológico elevado para o nível 9. [station_name()] está agora trancada, sob a Diretiva 7-10, até nova ordem."

	..()

/datum/command_alert/biohazard_station_nuke
	name = "Nível de Perigo Biológico Atualizado - Força Nuclear Autorizada"
	alert_title = "Medida Final"
	noalert = 1

/datum/command_alert/biohazard_station_nuke/announce()
	message = "O estado de contenção do surto de risco biológico atingirá uma massa crítica, sendo agora possível uma falha total da quarentena. Como tal, a Diretiva 7-12 foi agora autorizada para [station_name()]."

	..()

////////BLOB (mini)

/datum/command_alert/biohazard_level_5
	name = "Alerta de Risco Biológico (nível 5)"
	alert_title = "Alerta de Risco Biológico"
	alert = 'sound/AI/outbreak5.ogg'
	force_report = 1

/datum/command_alert/biohazard_level_5/announce()
	message = "Confirmado surto de risco biológico de nível 5 a bordo da [station_name()]. Toda a tripulação deve conter o surto."

	..()

/////////ERT

/datum/command_alert/ert_fail
	name = "ERT - Incapaz de Enviar"

/datum/command_alert/ert_fail/announce()
	message = "Parece que foi solicitada uma equipa de resposta a emergências para [station_name()]. Infelizmente, não conseguimos enviar uma neste momento."

	..()

/datum/command_alert/ert_success
	name = "ERT - Time Enviado"

/datum/command_alert/ert_success/announce()
	message = "Parece que foi solicitada uma equipa de resposta a emergências para a [station_name()]. Vamos preparar e enviar uma o mais rápido possível."

	..()

////////AYY

/datum/command_alert/xenomorphs
	name = "Alerta de sinais de vida não identificados"
	alert_title = "Alerta de sinais de vida"
	alert = 'sound/AI/aliens.ogg'

/datum/command_alert/xenomorphs/announce()
	message = "Sinais de vida não identificados detectados a bordo da [station_name()]. Proteger qualquer acesso exterior, incluindo dutos e ventilação."

	..()

///////RADIATION

/datum/command_alert/radiation_storm
	name = "Tempestade de Radiação - Aviso"
	alert_title = "Alerta de Anomalia"
	alert = 'sound/AI/radiation.ogg'
	message = "Níveis elevados de radiação detectados perto da estação, ETA em 30 segundos. Por favor, evacuar para um dos túneis de manutenção blindados."

/datum/command_alert/radiation_storm/start
	name = "Tempestade de Radiação - Início"
	alert = null
	message = "A estação entrou no cinturão de radiação. Por favor, permaneça em uma área protegida até que tenhamos passado pelo cinturão de radiação."

/datum/command_alert/radiation_storm/end
	name = "Tempestade de Radiação - Fim"
	alert = null
	message = "A estação passou o cinturão de radiação. Por favor, dirija-se à Medbay se tiver quaisquer sintomas incomuns. A manutenção perderá todo o acesso novamente em breve."

/datum/command_alert/radiation
	name = "Altos Níveis de Radiação"
	alert_title = "Alerta de Anomalia"
	alert = 'sound/AI/radiation.ogg'

	message = "Altos níveis de radiação detectados perto da estação. Se você se sentir estranho, dirija-se à Enfermaria Médica."


///////GRAYTIDE VIRUS

/datum/command_alert/graytide
	name = "Gr3y.T1d3 vírus"
	alert_title = "Alerta de Segurança"

/datum/command_alert/graytide/announce()
	message = "[pick("Gr3y.T1d3 virus", "Trojan Maligno")] detectado nas subrotinas de aprisionamento da [station_name()]. Recomendamos o envolvimento da IA da estação."

	..()

//////CARP

/datum/command_alert/carp
	name = "Migração de Carpas"
	alert_title = "Alerta de sinais de vida"

/datum/command_alert/carp/announce()
	message = "Entidades biológicas desconhecidas foram detectadas perto da [station_name()], por favor aguarde."

	..()

////////ELECTRICAL STORM

/datum/command_alert/electrical_storm
	name = "Tempestade Elétrica"
	alert_title = "Alerta de Tempestade Elétrica"
	message = "Foi detectada uma tempestade eléctrica na sua área, por favor repare potenciais sobrecargas eletrônicas."

///////SUMMARY DOWNLOADED AND PRINTED AT COMMS

/datum/command_alert/enemy_comms_interception
	name = "Comunicações Inimigas Interceptadas"
	alert_title = "Intercepção de comunicações inimigas"
	message = "Resumo baixado e impresso em todos os consoles de comunicação."

//////////SUPERMATTER CASCADE

/datum/command_alert/supermatter_cascade
	name = "Início da Cascata de Supermatéria"
	alert_title = "CASCATA DE SUPERMATÉRIA DETECTADA"

/datum/command_alert/supermatter_cascade/announce()
	message = {"
Ocorreu um pulso eletromagnético intergaláctico. Todos os nossos sistemas foram severamente danificados e muitos da equipe estão mortos ou morrendo. Estamos observando indicações crescentes de que o próprio universo está começando a se desfazer.

[station_name()], você é a única instalação perto de uma fenda no Bluespace, a qual é perto do seu posto avançado de pesquisa. Vocês foram designados a entrar na fenda usando todos os meios necessários, possivelmente como os últimos humanos vivos.

Vocês tem cinco minutos antes do universo entrar em colapso. Boa s\[\[###!!!-

ALERTA AUTOMATIZADO: O link para [command_name()] foi perdido.

Os requisitos de acesso aos consoles das Shuttles do Asteróide foram revogados.
"}

	..()

/////////////POWER OUTAGE

/datum/command_alert/power_outage
	name = "Queda de Energia - Início"
	alert_title = "Falha de Energia Crítica"
	alert ='sound/AI/poweroff.ogg'

/datum/command_alert/power_outage/announce()
	message = "Atividade anormal detectada na rede de energia de [station_name()]. Como medida precautória, a energia da estação será desligada por duração indeterminada."

	..()

/datum/command_alert/power_restored
	name = "Queda de Energia - Fim"
	alert_title = "Sistemas de Energia Nominais"
	alert = 'sound/AI/poweron.ogg'

/datum/command_alert/power_restored/announce()
	message = "A energia foi restaurada na [station_name()]. Nos desculpamos pela inconveniência."

	..()

/datum/command_alert/smes_charged
	name = "SMES Recarregada"
	alert_title = "Sistemas de Energia Nominais"
	alert = 'sound/AI/poweron.ogg'

/datum/command_alert/smes_charged/announce()
	message = "Todas as SMES na [station_name()] foram recarregadas. Nos desculpamos pela inconveniência."

	..()

////////////////WORMHOLES

/datum/command_alert/wormholes
	name = "Anomalias no Espaço-Tempo Detectadas"
	alert_title = "Alerta de Anomalia"
	alert = 'sound/AI/spanomalies.ogg'
	message = "Anomalias no espaço-tempo detectadas na estação. Não há dados adicionais."

//////////////MALF ANNOUNCEMENT

/datum/command_alert/malf_announce
	name = "Aviso de AI Defeituosa"
	alert_title = "Alerta de Anomalia"
	alert = 'sound/AI/aimalf.ogg'
	message = "Programas hostis detectados em todos os sistemas da estação, favor desativar a AI para prevenir possível dano ao seu núcleo moral."

/////////////METEOR STORM

/datum/command_alert/meteor_round
	name = "Aviso de Tempestade de Meteoros Grave"
	alert_title = "Anúncios Automatizados de Meteorologia Espacial"
	alert = 'sound/AI/meteorround.ogg'

	var/meteor_delay = 2000
	var/supply_delay = 100

/datum/command_alert/meteor_round/announce()
	meteor_delay = rand(4500, 6000)
	if(prob(70)) //slightly off-scale
		message = "Uma tempestade de meteoros foi detectada na proximidade da [station_name()] e espera-se que a atinja dentro de [round((rand(meteor_delay - 600, meteor_delay + 600))/600)] minutos. Uma shuttle emergencial reserva está sendo despachada e o equipamento de emergência deve ser teletransportado para a área do Bar de sua estação em [supply_delay/10] segundos."
	else
		message = "Uma tempestade de meteoros foi detectada na proximidade da [station_name()] e espera-se que a atinja dentro de [round((rand(meteor_delay - 1800, meteor_delay + 1800))/600)] minutos. Uma shuttle emergencial reserva está sendo despachada e o equipamento de emergência deve ser teletransportado para a área do Bar de sua estação em [supply_delay/10] segundos."

	..()

////small meteor storm

/datum/command_alert/meteor_wave
	name = "Aviso de Tempestade de Meteoros"
	alert_title = "Alerta de Meteoro"
	alert = 'sound/AI/meteors.ogg'
	message = "Uma tempestade de meteoros foi detectada em rota de colisão com a estação. Procure abrigo dentro do núcleo da estação imediatamente."


/////meteor storm end
/datum/command_alert/meteor_wave_end
	name = "Tempestade de Meteoros Eliminada"
	alert_title = "Alerta de Meteoro"
	message = "A estação eliminou a tempestade de meteoros."

/datum/command_alert/meteor_storm
	name = "Aviso de Tempestade de Meteoros de Pequena Intensidade"
	alert_title = "Alerta de Meteoro"
	message = "A estação está prestes a ser atingida por uma pequena tempestade de meteoros. Procure abrigo dentro do núcleo da estação imediatamente."

//////blob storm
/datum/command_alert/blob_storm
	name = "Meteoro com aglomerado de Blob - Sem Overminds"
	alert_title = "Aglomerado de Blob"
	message = "A estação está prestes a passar por um aglomerado de Blob. Nenhuma onda cerebral do Overmind detectadas."

/datum/command_alert/blob_storm/end
	name = "Meteoro com aglomerado de Blob encerrado (Zero Overminds)"
	message = "A estação limpou o aglomerado de Blob. Erradicar o Blob das áreas atingidas."

/datum/command_alert/blob_storm/overminds
	name = "Meteoro com aglomerado de Blob - Overminds!"
	alert_title = "Conglomerado de Blob"
	message = "A estação está prestes a passar por um conglomerado de Blob. Ondas cerebrais do Overmind possivelmente detectadas."

/datum/command_alert/blob_storm/overminds/end
	name = "Meteoro com aglomerado de Blob encerrado (Overminds!)"
	message = "A estação eliminou o conglomerado de Blob. Investigue as áreas atingidas imediatamente e limpe-as. Seja cuidadoso com a possível presença de Overmind."

/////////////GRAVITY

/datum/command_alert/gravity_enabled
	name = "Gravidade - Ativada"
	message = "Geradores de gravidade estão novamente funcionando dentro dos parâmetros normais. Sinceras desculpas por qualquer inconveniência."

/datum/command_alert/gravity_disabled
	name = "Gravidade - Desativada"
	message = "Surtos de realimentação detectados em sistemas de distribuição de massa. A gravidade artificial foi desativada enquanto o sistema reinicializa. Outras falhas podem resultar em colapso gravitacional e formação de buracos negros. Tenha um bom dia."

//////////////////////////////ION STORM

/datum/command_alert/ion_storm
	name = "Tempestade Iônica - IA afetado"
	alert_title = "Alerta de Anomalia"
	alert = 'sound/AI/ionstorm.ogg'
	message = "Tempestade iónica detectada perto da estação. Por favor, verifique se há erros em todos os equipamentos controlados por AI."

/datum/command_alert/ion_storm_large
	name = "Tempestade Iônica - Todos os equipamentos afetados"
	alert_title = "Alerta de Anomalia"
	message = "Nós detectamos que a estação acabou de passar por uma tempestade iônica. Por favor, monitore todos os equipamentos eletrônicos por erros em potencial."

///////////BLUESPACE ANOMALY

/datum/command_alert/bluespace_anomaly
	name = "Anomalia de Bluespace"
	alert_title = "Alerta de Anomalia"

/datum/command_alert/bluespace_anomaly/New(impact_area_name)
	message = "Anomalia de Bluespace detectada nos arredores da [station_name()]. [impact_area_name || "Uma área desconhecida"] foi afetada."
	..()

//////////POWER DISABLED

/datum/command_alert/power_disabled
	name = "Energia da Estação - Desativada"
	alert_title = "Exame de Rede Automatizado"
	alert = 'sound/AI/poweroff.ogg'

/datum/command_alert/power_disabled/announce()
	message = "Atividade anormal foi detectada na rede de energia da [station_name()]. A energia será desligada por tempo indeterminado por questões de segurança."
	..()

/datum/command_alert/power_restored
	name = "Energia da Estação - Restaurada"
	alert_title = "Potência Nominal"
	alert = 'sound/AI/poweron.ogg'

/datum/command_alert/power_restored/announce()
	message = "Energia foi restaurada na [station_name()]. Sinceras desculpas pela inconveniência."
	..()

//////////////CENTCOM LINK

/datum/command_alert/command_link_lost
	name = "Conexão Perdida com a CentCom"
	alert_title = "Alerta Automático"
	alert = 'sound/AI/loss.ogg'
	message = "Isso é um alerta automático. A conexão com o comando central foi perdida. Novamente: A conexão com o comando central foi perdida. Tentando a re-estabelecer comunicações em T-10."

/datum/command_alert/command_link_restored
	name = "Conexão com a CentCom Restaurada"
	alert_title = "Conexão Estabelecida"

/datum/command_alert/command_link_restored/announce()
	message = "Conexão com o comando central foi estabelecida na [station_name()]."
	..()

/////////HOSTILE CREATURES

/datum/command_alert/hostile_creatures
	name = "Alerta de Criaturas Hostis"
	alert_title = "AVISO: Criatura(s) Hostis"

/datum/command_alert/hostile_creatures/New(localestring = "um local desconhecido", monsterstring = "intenção maliciosa")
	..()

	message = "Uma ou mais criatura(s) hostil(is) invadiram a estação em [localestring]. Câmeras de segurança externas indicam que a criatura possui [monsterstring]."

/datum/command_alert/vermin
	name = "Alerta de Vermes"
	alert_title = "Infestação de Vermes"

/datum/command_alert/vermin/New(vermstring = "vários vermes", locstring = "túneis de manutenção da estação")
	..()

	message = "Bioscans indicam que [vermstring] tem se reproduzido nos [locstring]. Esvazie-os, antes que isso comece a afetar a produtividade."

/datum/command_alert/mob_swarm
	name = "Enxame de Criaturas"

/datum/command_alert/mob_swarm/New(mob_name = "animais")
	..()

	message = "Devido a anomalias de origem desconhecidas no espaço-tempo, a [station_name] agora é a hospedeira de vários [mob_name], mais do que havia há pouco."

////////MISC STUFF

/datum/command_alert/eagles
	name = "Acesso da Airlock Removido"
	message = "Controle da Airlock da Centcomm sobreposto. Por favor, tome este tempo para se familiarizar com seus colegas de trabalho."

/datum/command_alert/bluespace_artillery
	name = "Ataque de Artilharia Bluespace Detectado"
	message = "Fogo de artilharia Bluespace detectado. Preparar para impacto."

/datum/command_alert/vending_machines
	name = "Inteligência de Marca Rampante Detectada"
	alert_title = "Alerta de aprendizado de máquina"

/datum/command_alert/vending_machines/announce()
	message = "A inteligência da marca Rampant foi detectada a bordo de [station_name()], por favor, aguarde."

/datum/command_alert/comms_blackout
	name = "Anomalias Ionosféricas - Falha nas Telecomunicações"
	message = "Anomalias ionosféricas detectadas. Falha temporária de telecomunicações iminente. Favor entrar em contato com seu-BZZT"

/datum/command_alert/comms_blackout/announce()
	message = pick(	"Anomalias ionosféricas detectadas. Falha temporária na telecomunicação iminente. Por favor contate seu%fj00)`5vc-BZZT", \
						"Anomalias ionosféricas detectadas. Falha temporária na telecomun3mga;b4;'1v¬-BZZZT", \
						"Anomalias ionosféricas detectadas. Falha temporár#MCi46:5.;@63-BZZZZT", \
						"Anomalias ionosféricas detec'fZ\\kg5_0-BZZZZZT", \
						"Anomali:%£ MCayj^j<.3-BZZZZZZT", \
						"#4nd%;f4y6,>£%-BZZZZZZZT")
	..()

/datum/command_alert/electrical_storm
	name = "Alerta de Tempestade Elétrica"
	alert_title = "Alerta de Tempestade Elétrica"
	message = "Uma tempestade eléctrica foi detectada na sua área, por favor repare potenciais sobrecargas eletrônicas."

/datum/command_alert/immovable_rod
	name = "Haste Imóvel (\"Que diabos foi isso?\")"
	alert_title = "Alerta Geral"
	message = "Que diabos foi isso?!"

/datum/command_alert/rogue_drone
	name = "Drones Rebeldes - Alerta"
	alert_title = "Alerta de Drones Rebeldes"

/datum/command_alert/rogue_drone/announce()
	if(prob(33))
		message = "Um drone de combate operando fora da NMV Icarus falhou em retornar de uma varredura nesse setor, se algum for avistado aproxime-se com cuidado."
	else if(prob(50))
		message = "Contato foi perdido com um drone de combate operando fora da NMV Icarus. Se alguma for avistada na área, aproxime-se com cuidado."
	else
		message = "Hackers não identificados atacaram um drone de combate enviado da NMV Icarus. Se algum for avistado, aproxime-se com cuidado."

	..()

/datum/command_alert/drones_recovered
	name = "Drones Rebeldes - Recuperados com Sucesso"
	alert_title = "Alerta de Drones Rebeldes"
	message = "Icarus reporta que seu drone com malfuncionamento foi recuperado com segurança."

/datum/command_alert/drones_recovered/failure
	name = "Drones Rebeldes - Falha em recuperar"
	message = "Icarus registra desapontamento pela perda de seus drones, mas os sobreviventes foram recuperados."

/datum/command_alert/wall_fungi
	name = "Parede de Fungos"
	alert_title = "Alerta de Risco Biológico"
	message = "Fungos perigosos detectados na estação. Estruturas da estação podem estar contaminadas."
