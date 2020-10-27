-- Portuguese localization file for ptBR. Credit: Cara
local L = ElvUI[1].Libs.ACL:NewLocale("ElvUI", "ptBR")

-- WoW Locales
L["CLASS_COLORS"] = "Cores de classes";
L["COLOR_PICKER"] = "Seletor de cor";
L["EDIT"] = "Editar";
L["HOME"] = "Início";
L["WORLD"] = "Mundo";

-- core
L['is loaded. For any issues or suggestions, please visit'] = "carregado. Para qualquer problema ou sugestão, por favor acesse"
L["%s\n\nYour ElvUI version %.2f is not compatible with BenikUI.\nLatest ElvUI version is %.2f. Please download it from here:\n"] = "%s\n\nA sua versão %.2f do ElvUI não é compativel com o BenikUI.\nA ultima versão do ElvUI é a %.2f. Por favor, baixe aqui:\n"
L["|cffff0000BenikUI Error|r\n\nIt seems like BenikUI Retail version is installed on WoW Classic. Please install BenikUI Classic version.\n|cff00c0faTip: Usually happens with Twitch Client|r"] = "|cffff0000Erro BenikUI|r\n\nParece que instalou o BenikUI versão Retail no WoW Clássico. Por favor instale o BenikUI versão Clássico.\n|cff00c0faDica: Normalmente acontece com o Twitch Client|r"

-- General options
L["BenikUI is a completely external ElvUI mod. More available options can be found in ElvUI options (e.g. Actionbars, Unitframes, Player and Target Portraits), marked with "] = "BenikUI é um  mod completamente separado do ElvUI. Mais opções estão disponiveis nas opções do ElvUI. (ex. Barras de Ação, Placas de identificação, Retratos do jogador e alvo), marcadas com "
L["Credits:"] = "Créditos"
L['ActionBar Style Color'] = "Cor do Estilo das Barras de Ações"
L['BenikUI Style'] = "Estilo BenikUI"
L['Enable/Disable the decorative bars from UI elements'] = "Liga/Desliga as barras decorativas dos elementos da interface"
L['Hide BenikUI Style'] = "Esconder Estilo BenikUI"
L['Show/Hide the decorative bars from UI elements. Usefull when applying Shadows, because BenikUI Style must be enabled. |cff00c0faNote: Some elements like the Actionbars, Databars or BenikUI Datatexts have their own Style visibility options.|r'] ="Mostra/Esconde as barras decorativas dos elementos da interface. Útil ao aplicar Sombras, porque o Estilo BenikUI tem que estar ligado. |cff00c0faNote: Alguns elementos como Barras de Ações, Barras de dados ou Textos Informativos do BenikUI têm as suas própias opções de visibilidade do Estilo.|r'"
L['Game Menu Color'] = "Cor do Menu de Jogo"
L['Style Color'] = "Cor do Estilo"
L['by Benik (EU-Emerald Dream)'] = "por Benik (EU-Emerald Dream)"
L['light blue color.'] = "cor azul claro"
L['Splash Screen'] = "Tela de inicio"
L['Shadow'] = "Sombra"

L['Shadow Size'] = "Tamanho da Sombra"
-- Layout
L['LeftClick: Toggle Configuration'] = "LeftClick: Alterna Configuração"
L['RightClick: Toggle Embedded Addon'] = "RightClick: Alterna Addon Embutido"
L['ShiftClick to toggle chat'] = "ShiftClick para alternar bate-papo"
L['Click to show the Addon List'] = "Clique para mostrar a lista de Addons"

-- Custom Panels
L['Create'] = "Criar"
L['Enable tooltip to reveal the panel name'] = "Mostra o nome do painel na dica de contexto"
L['Hide In Combat'] = "Esconder Em Combate"
L['Hide in Pet Battle'] = "Esconder Em Batalhas de Pet"
L['Name Tooltip'] = "Nome na Dica de contexto"
L['Texture Color'] = "Cor da Textura"
L['The Custom Panel name |cff00c0fa%s|r already exists. Please choose another one.'] = "O nome do painel personalizado |cff00c0fa%s|r já existe. Por favor escolha outro nome."
L['This will delete the Custom Panel named |cff00c0fa%s|r. This action will require a reload.\nContinue?'] = "Isto vai apagar o painel personalizado com o nome |cff00c0fa%s|r. Esta ação precisa que recarregue a interface.\nContinuar?"
L['This works like a macro, you can run different situations to get the panel to show/hide differently.\n Example: "[combat] show;hide"'] = 'Isto funciona como uma macro, pode configurar várias situações para esconder ou mostrar o painel.\n Examplo: "[combat] show;hide"'
L['Title Bar Position'] = "Posição da Barra de Título"
L['Title Text Position'] = "Posição do Texto de Título"
L['Title'] = "Título"
L['Type a unique name for the new panel. \n|cff00c0faNote: "BenikUI_" will be added at the beginning, to ensure uniqueness|r'] = 'Escreva um nome único para o painel. \n|cff00c0faNota: Vai ser acrescentado "BenikUI_" ao inicio do nome, para garantir que é único|r'

-- Profiles
L['Successfully created and applied profile(s) for |cffffff00%s|r'] = 'Perfis para |cffffff00%s|r criados e aplicados com sucesso' -- %s is the addon name
L['|cffffff00%s|r profile for this character already exists. Aborting.'] = 'Perfil |cffffff00%s|r para este personagem já existe. Abortando.' -- %s is the addon name

-- Misc
L['Shown Logo'] = "Mostrar Logo"
L['iLevel'] = "iLevel"
L['Show item level per slot, on the character info frame'] = "Mostrar nivel dos items por slot, na folha de informação do personagem"
L['Inside the item slot'] = "Dentro do slot do item"
L['Outside the item slot'] = "Fora do slot do item"

-- Flight mode
L['Exit FlightMode'] = "Sair do Modo de Voo"
L['Show an enhanced game menu'] = "Mostrar menu de jogo melhorado"
L['Toggle Location and Coords'] = "Alterna Localização e Coordenadas"
L['Toggle World Map'] = "Alterna Mapa do Mundo"
L['Display the Flight Mode screen when taking flight paths'] = "Mostra o ecran do Modo de Voo quando apanha um ponto de voo"

-- DataTexts
L['BenikUI Middle DataText'] = "Texto informativo BenikUI Centro"
L['Hide Mail Icon'] = "Esconde icone do Correio"
L['Middle'] = "Centro"
L['New Mail'] = "Novo Correio"
L['No Mail'] = "Sem Correio"
L['Set Datatext Values'] = "Definir Valores do Texto Informativo"
L['Show/Hide Chat DataTexts. ElvUI chat datatexts must be disabled'] = "Mostra/Esconde Textos informativos do Bate-papo. Os textos informativos do ElvUI precisam de estar desligados."
L['Show/Hide Mail Icon on minimap'] = "Mostra/Esconde icone do Correio no minimapa"
L['Styles the chat datetexts and buttons only if both chat backdrops are set to "Hide Both".'] = 'Aplica o estilo aos textos informativcs e botões de bate-papo apenas se ambos os panos de fundo do bate-papo estiverem definidos como "Esconder ambos".'
L['Left Chat Panel'] = "Painel de bate-papo esquerdo"
L['Right Chat Panel'] = "Painel de bate-papo direito"
L['Middle Panel'] = "Painel Central"

-- install
L["BenikUI didn't find any supported addons for profile creation"] = "O BenikUI não encontrou nenhum addon suportado para criar perfis."
L['BenikUI successfully created and applied profile(s) for:'] = "O BenikUI criou e aplicou com sucesso perfis para:"
L["By pressing the Continue button, BenikUI will be applied on your current ElvUI installation.\n\n|cffff8000 TIP: It would be nice if you apply the changes in a new profile, just in case you don't like the result.|r"] = "Ao carregar no botão Continuar,  o BenikUI vai ser aplicado na sua instalação do ElvUI.\n\n|cffff8000 Dica: Seria bom se aplicasse as alterações num perfil novo, caso não goste do resultado.|r"
L["This part of the installation process will fill BenikUI datatexts.\n\n|cffff8000This doesn't touch ElvUI datatexts|r"] = "Esta parte do processo de instalação vai preencher os Textos informativos do BBenikUI.\n\n|cffff8000Isto não altera os textos informativos do ElvUI|r"
L["This part of the installation process will reposition your Unitframes."] = "Esta parte do processo de instalação vai reposicionar as suas placas de identificação."
L['Actionbars Set'] = "Barras de Ação definidas"
L['Addons Set'] = "Addons definidos"
L['BenikUI options are marked with light blue color, inside ElvUI options.'] = "As opções do BeniUI estão marcadas com a cor azul claro, dentro das opções do ElvUI."
L['Color Theme Set'] = "Cor do Tema definida"
L['Color Themes'] = "Cor do Tema"
L['DataTexts Set'] = "Textos informativos definidos"
L['Diablo'] = "Diablo"
L['ElvUI'] = "ElvUI"
L['Hearthstone'] = "Heartstone"
L['Installation'] = "Instalação"
L['Mists'] = "Mists"
L['Please click a button below to apply a color theme.'] = "Por favor clique um dos botões abaixo para aplicar uma Cor do Tema."
L['Please click the button below to apply the new layout.'] = "Por favor clique um dos botões abaixo para aplicar a nova disposição."
L['Please click a button below to setup your Unitframes.'] = "Por favor clique um dos botões abaixo para configurar as suas Placas de Identificação."
L['Please click a button below to setup your actionbars.'] = "Por favor clique um dos botões abaixo para configurar as suas Barras de Ação."
L['Please click the button below to setup your addons.'] = "Por favor clique o botão abaixo para configurar os seus addons."
L['Please click the button below to setup your chat windows.'] = "Por favor clique o botão abaixo para configurar as janelas de bate-papo."
L['Please click the button below to setup your datatexts.'] = "Por favor clique o botão abaixo para configurar os Textos Informativos."
L['Setup Addons'] = "Configurar Addons"
L['Setup Layout'] = "Configurar disposição"
L['This part of the installation process sets up your chat fonts and colors.'] = "Esta parte do processo de instalação configura as fontes e cores do bate-papo."
L['This part of the installation process will create and apply profiles for addons like Recount, DBM, ElvUI plugins, etc'] = "Esta parte do processo de instalação vai criar e aplicar os perfis para os addons como Recount, DBM, Plugins do ElvUI, etc"
L['This part of the installation process will reposition your Actionbars and will enable backdrops'] = "Esta parte do processo de instalação vai reposicionar as suas Barras de Ação e ligar o pano de fundo das mesmas"
L['This part of the installation will apply a Color Theme'] = "Esta parte da instalação vai aplicar uma Cor do Tema"
L['This part of the installation will change the default ElvUI look.'] = "Esta parte da instalação vai mudar o aspecto por defeito do ElvUI."
L['UnitFrames'] = "Placas de Identificação"
L['Unitframes Set'] = "Placas de Identificação definidas"
L['Welcome to BenikUI version %s, for ElvUI %s.'] = 'Bem-vindo ao BenikUI versão %s, para o ElvUI %s'
L['Welcome'] = "Bem-vindo" 
L['You are now finished with the installation process. If you are in need of technical support please visit us at https://www.tukui.org.'] = 'Terminou o proocesso de instalação. Se precisa de suporte por favor acesse https://www.tukui.org.'

-- actionbar options
L['Bar 1'] = "Barra 1"
L['Bar 2'] = "Barra 2"
L['Choose Actionbar to show to'] = "Escolha a Barra de Ação para mostrar"
L['Request Stop button'] = "Botão de Pedir Paragen"
L['Show in:'] = "Mostrar em:"
L['Show small buttons over Actionbar 1 or 2 decoration, to show/hide Actionbars 3 or 5.'] = "Mostrar botões pequenos acima da decoração da Barra de Ação 1 ou 2, para mostrar/esconder as barras 3 ou 5."
L['Switch Buttons (requires BenikUI Style)'] = "Trocar Botões (precisa do Estilo BenikUI)"

-- Request stop button
L['LeftClick to Request Stop'] = "LeftClick para Pedir Paragem"
L['RightClick to Hide'] = "RightClick para Esconder"

-- afk Mode
L["Logout Timer"] = "Temporizador para deslogar"
L["Random Stats"] = "Estatisticas Variadas"
L["remaining till level"] = "faltando para nivel"

-- Dashboards
L['Amount'] = "Quantidade"
L['Bar Color'] = "Cor da Barra"
L["Change the Professions Dashboard width."] = "Altera a largura do Painel de Profissões."
L['Change the System Dashboard width.'] = "Altera a largura do Painel de Sistema."
L["Change the Tokens Dashboard width."] = "Altera a largura do Painel de Tokens."
L['Choose font for all dashboards.'] = "Escolha a fonte para todos os painéis."
L['Click :'] = "Clique :"
L['Dashboards'] = "Painéis"
L["Enable the Professions Dashboard."] = "Habilita o Painel de Profissões."
L['Enable the System Dashboard.'] = "Habilita o Painel de Sistema."
L['Enable the Tokens Dashboard.'] = "Habilita o Painel de Tokens."
L['Enable/Disable'] = "Habilita/Desabilita"
L["Filter Capped"] = "Filtrar terminadas."
L['Latency (MS)'] = "Latência (MS)"
L['MouseWheel :'] = "MouseWheel :"
L['RightClick :'] = "RightClick :"
L['Select Professions'] = "Escolha Profissões"
L['Select System Board'] = "Escolha Painel de Sistema"
L['Select Tokens'] = "Escolha Tokens"
L['Set the font size.'] = "Defina o tamanho da fonte."
L['Shift+RightClick to remove'] = "Shift+RightClick para remover"
L['Show the token, even if the amount is 0'] = "Mostrar o token mesmo que a quantidade seja 0"
L['Show Weekly max'] = "Mostrar Máx Semanal"
L['Show Weekly max tokens instead of total max'] = "Mostrar Máx Semanal de tokens em vez do Máx Total"
L['Show zero amount tokens'] = "Mostrar tokens com quantidade zero"
L['Show/Hide System Dashboard when in combat'] = "Mostra/Esconde o Painel de Sistem em combate"
L['Show/Hide Tokens Dashboard when in combat'] = "Mostra/Esconde o Painel de Tokens em combate"
L['Show/Hide Tooltips'] = "Mostra/Esconde Dica de contexto"
L['System'] = "Sistema"
L['Tip: Grayed tokens are not yet discovered'] = "Dica: Tokens a cinzento ainda não foram descobertos"
L['Tip: Click to free memory'] = "Dica: Clique para libera memória"
L['Use DataTexts font'] = "Usar fonte dos Textos Informativos"
L['Use Faction Colors on Bars'] = "Usar cor da Fação nas Barras"
L['Use Faction Colors on Text'] = "Usar cor da Fação no Texto"

-- Databars Options
L['Notifiers'] = "Notificadores"
L['Button Backdrop'] = "Pano de fundo dos Botões"
L['Without Backdrop'] = "Sem pano de fundo"

-- Skins Options
L['AddOnSkins'] = "AddOnSkins"
L['AddOns Decor'] = "Addons Decor"
L['Choose which addon you wish to be decorated to fit with BenikUI style'] = "Escolha o addon para ser decorado no estilo BenikUI"
L['ElvUI AddOns'] = "Addons ElvUI"
L['decor.'] = true
L['This will create and apply profile for '] = "Isto vai criar e aplicar o perfil para "
L['Profiles'] = "Perfis"

-- UnitFrame Options
L['Apply shadow under the portrait'] = "Aplica sobra embaixo do Retrato"
L['Apply transparency on the portrait backdrop.'] = "Aplica transparência no pano de fundo do Retrato"
L['BenikUI Style on Portrait'] = "Estilo BenikUI no Retrato"
L['Castbar Backdrop Color'] = "Cor do pano de fundo da Barra de cast"
L['Castbar Text'] = "Texto da Barra de cast"
L['Change the detached portrait height'] = "Altera a altura do Retrato separado"
L['Change the detached portrait width'] = "Altera a largura do Retrato separado"
L['Copy Player portrait width and height'] = "Copia a altura e largura do Retrato do Jogador"
L['Detach Portrait'] = "Separar Retrato"
L['Fix InfoPanel width'] = "Arranjar largura do Painel de Informações"
L['Health statusbar texture. Applies only on Group Frames'] = "Textura da Barra de Saude"
L['Ignore Transparency'] = "Ignorar trasparência"
L['Lower InfoPanel width when potraits are enabled.'] = "Painel de Informações menor quando os retratos estão habilitados"
L['Makes the portrait backdrop transparent'] = "Torna o pano de fundo do retrato transparente"
L['Player Size'] = "Tamanho do jogador"
L['Power statusbar texture.'] = "Textura da Barra de Poder"
L['Replaces the default role icons with SVUI ones.'] = "Substitui os icones de função com os icones SVUI."
L['Style Height'] = "Altura do estilo"
L['SVUI Icons'] = "Icones SVUI"
L['This will ignore ElvUI Health Transparency setting on all Group Frames.'] = "Ignora a definição de transparência de Saude do ElvUI em todas as frames de grupo."
L['Vertical power statusbar'] = "Barra de poder vertical"

-- Castbar
L['Force show any text placed on the InfoPanel, while casting.'] = "Força mostrar qualquer texto colocado no Painel de informações, enquanto faz cast"
L['Show Castbar text'] = "Mostrar texto da barra de cast"
L['Show InfoPanel text'] = "Mostrar texto do Painel de informações"
L['Show on Target'] = "Mostrar no alvo"
L['This applies on all available castbars.'] = "Isto aplica-se a todas as barras de cast disponiveis."

-- Raid
L['Class Hover'] = "Classe ao pairar"
L['Enable Class color on health border, when mouse over'] = "Habilita a cor da classe nos bordos da saúde ao pairar com o rato."

-- Information
L['Information'] = "Informação"
L['Support'] = "Suporte"
L['Download'] = "Baixar"
L['Beta versions'] = "Versão Beta"
L['Coding'] = "Programado por"
L['Testing & Inspiration'] = "Testes & Inspiração"
L['Donations'] = "Doaçãoes"
L['My other Addons'] = "Os meus outros Addons"
L['Discord Server'] = "Servidor Discord"
L['Git Ticket tracker'] = "Gestão de tickets Git"
L['Tukui.org'] = "Tukui.org"
-- Location Plus
L['Adds player location, coords + 2 Datatexts and a tooltip with info based on player location/level.'] = "Adiciona a localização do jogador, coordenadas + 2 Textos informativos e um Dica de contexto com informação baseada na localização/nível do jogador"
-- Nuts & Bolts
L['ElvUI Nuts & Bolts is a compilation of my addons hosted at tukui.org/Twitch plus some features that are moved from BenikUI'] = "ElvUI Nuts & Bolts é uma compilação dos meus addons hospedados em tukui.org/Twitch mais algumas funcionalidades que movidas do BenikUI"

-- afk
L["Jan"] = "Jan"
L["Feb"] = "Fev"
L["Mar"] = "Mar"
L["Apr"] = "Abr"
L["May"] = "Mai"
L["Jun"] = "Jun"
L["Jul"] = "Jul"
L["Aug"] = "Ago"
L["Sep"] = "Set"
L["Oct"] = "Out"
L["Nov"] = "Nov"
L["Dec"] = "Dez"

L["Sun"] = "Dom"
L["Mon"] = "Seg"
L["Tue"] = "Ter"
L["Wed"] = "Qua"
L["Thu"] = "Qui"
L["Fri"] = "Sex"
L["Sat"] = "Sab"

-- Addon friendly names (no need to translate)
L['Altoholic'] = true
L['AtlasLoot'] = true
L['Clique'] = true
L['Details'] = true
L['ElvUI_Enhanced'] = true
L['LocationPlus'] = true
L['Recount'] = true
L['Shadow & Light'] = true
L['Skada'] = true
L['TinyDPS'] = true
L['oRA3'] = true
L['Deadly Boss Mods'] = true
L['BigWigs'] = true
L['Zygor Guides'] = true
L['Immersion'] = true
L['Project Azilroka'] = true
