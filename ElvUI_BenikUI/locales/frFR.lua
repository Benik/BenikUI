-- French localization file for frFR. Credits: Pristie
local L = ElvUI[1].Libs.ACL:NewLocale("ElvUI", "frFR")

-- WoW Locales
L["CLASS_COLORS"] = "Couleurs de classe";
L["COLOR_PICKER"] = "Palette de couleurs";
L["EDIT"] = "Editer";
L["HOME"] = "Accueil";
L["WORLD"] = "Monde";

-- core
L['is loaded. For any issues or suggestions, please visit'] = "est chargé. Pour toute question ou suggestion, veuillez consulter le site "
L["%s\n\nYour ElvUI version %.2f is not compatible with BenikUI.\nLatest ElvUI version is %.2f. Please download it from here:\n"] = "%s\n\nVotre version ElvUI %.2f n'est pas compatible avec BenikUI.\nLa dernière version ElvUI est %.2f. Veuillez la télécharger ici :"
L["|cffff0000BenikUI Error|r\n\nIt seems like BenikUI Retail version is installed on WoW Classic. Please install BenikUI Classic version.\n|cff00c0faTip: Usually happens with Twitch Client|r"] = "|cffff0000BenikUI Erreur|r\n\n Il semble que la version BenikUI Retail soit installée sur WoW Classic. Veuillez installer la version BenikUI Classic. \n|cff00c0fa Astuce: Cela se produit généralement avec le client Twitch"

-- General options
L["BenikUI is a completely external ElvUI mod. More available options can be found in ElvUI options (e.g. Actionbars, Unitframes, Player and Target Portraits), marked with "] = "BenikUI est un mod pour ElvUI complètement externe. Plus d'options disponibles peuvent être trouvées dans les options ElvUI (par exemple les barres d'action, les unités, les portraits de joueur et cible), marquées par"
L["Credits:"] = "Crédits :"
L['ActionBar Style Color'] = "Couleur du style ActionBar"
L['BenikUI Style'] = true
L['Enable/Disable the decorative bars from UI elements'] = "Activer / désactiver les barres décoratives des éléments de l'interface utilisateur"
L['Hide BenikUI Style'] = "Masquer le style BenikUI"
L['Show/Hide the decorative bars from UI elements. Usefull when applying Shadows, because BenikUI Style must be enabled. |cff00c0faNote: Some elements like the Actionbars, Databars or BenikUI Datatexts have their own Style visibility options.|r'] = "Afficher/masquer les barres décoratives des éléments de l'interface utilisateur. Utile lors de l'application des ombres, car le style BenikUI doit être activé. |cff00c0faRemarque: Certains éléments comme les barres d'actions, les Barres de données ou BenikUI Texte des données ont leurs propres options de visibilité et de style.|r"
L['Game Menu Color'] = "Couleur du menu du jeu"
L['Style Color'] = "Couleur du style"
L['by Benik (EU-Emerald Dream)'] = true
L['light blue color.'] = "couleur bleu clair."
L['Splash Screen'] = "Écran de démarrage"
L['Shadow'] = "Ombre"
L['Shadow Size'] = "Taille de l'ombre"

-- Layout
L['LeftClick: Toggle Configuration'] = "Clic gauche: active la configuration"
L['RightClick: Toggle Embedded Addon'] = "Clic droit: active le module complémentaire intégré"
L['ShiftClick to toggle chat'] = "Shift Cliquez pour activer le chat"
L['Click to show the Addon List'] = "Cliquez pour afficher la liste des addons complémentaires"

-- Custom Panels
L["Create"] = "Créer"
L["Enable tooltip to reveal the panel name"] = "Activer l'info-bulle pour révéler le nom du panneau"
L["Hide In Combat"] = "Cacher au combat"
L["Hide in Pet Battle"] = "Cacher dans une bataille de mascottes"
L["Name Tooltip"] = "Info-bulle du nom"
L["Texture Color"] = true
L["The Custom Panel name |cff00c0fa%s|r already exists. Please choose another one."] = "Le nom du panneau personnalisé |cff00c0fa%s|r existe déjà. Veuillez en choisir un autre."
L["This will delete the Custom Panel named |cff00c0fa%s|r. This action will require a reload.\nContinue?"] = "Cela supprimera le panneau personnalisé nommé |cff00c0fa%s|r. Cette action nécessite un rechargement.\nContinuer?"
L["This works like a macro, you can run different situations to get the panel to show/hide differently.\n Example: '[combat] show;hide'"] = "Cela fonctionne comme une macro, vous pouvez l'exécuter dans différentes situations pour que le panneau s'affiche/masque différemment.\n Exemple: '[combat] afficher;masquer"
L["Title Bar Position"] = true
L["Title Text Position"] = true
L["Title"] = true
L["Type a unique name for the new panel. \n|cff00c0faNote: 'BenikUI_' will be added at the beginning, to ensure uniqueness|r"] = "Tapez un nom unique pour le nouveau panneau. \n|cff00c0faRemarque: 'BenikUI_' sera ajouté au début, pour garantir l'unicité|r"

-- Profiles
L['Successfully created and applied profile(s) for |cffffff00%s|r'] = "Profil créé et appliqué avec succès pour |cffffff00%s|r"-- %s is the addon name
L['|cffffff00%s|r profile for this character already exists. Aborting.'] = "|cffffff00%s|r le profil de ce personnage existe déjà. Abandon." -- %s is the addon name

-- Misc
L['Shown Logo'] = "Logo affiché"
L['iLevel'] = true
L['Show item level per slot, on the character info frame'] = "Affiche le niveau d'objet par emplacement, dans le cadre d'informations de votre personnage"
L['Inside the item slot'] = "Dans l'emplacement de l'objet"
L['Outside the item slot'] = "En dehors de l'emplacement de l'objet"

-- Flight mode
L['Exit FlightMode'] = "Quitter le mode voyage"
L['Show an enhanced game menu'] = "Afficher un menu du jeu amélioré"
L['Toggle Location and Coords'] = "Active la localisation et les coordonnées"
L['Toggle World Map'] = "Active sur Carte du monde"
L['Display the Flight Mode screen when taking flight paths'] = "Afficher l'écran Mode de vol lors de l'établissement des trajectoires de vol"

-- DataTexts
L['BenikUI Middle DataText'] = "BenikUI Texte des données au milieu"
L['Hide Mail Icon'] = "Masquer l'icône du courrier"
L['Middle'] = "Milieu"
L['New Mail'] = "Nouveau courrier"
L['No Mail'] = "Pas de courrier"
L['Set Datatext Values'] = true
L['Show/Hide Chat DataTexts. ElvUI chat datatexts must be disabled'] = "Affiche/masque les textes de données de discussion. Les textes de données de chat ElvUI doivent être désactivés"
L['Show/Hide Mail Icon on minimap'] = "Affiche/masque l'icône de courrier sur la minicarte"
L['Styles the chat datetexts and buttons only if both chat backdrops are set to "Hide Both".'] = "Stylise les textes de date et les boutons du chat que si les deux arrière-plans du chat sont réglés sur 'Cacher les deux'."
L['Left Chat Panel'] = true
L['Right Chat Panel'] = true
L['Middle Panel'] = true

-- install
L["BenikUI didn't find any supported addons for profile creation"] = "BenikUI n'a pas trouvé d'addons pris en charge pour la création de profil"
L['BenikUI successfully created and applied profile(s) for:'] = "BenikUI a créé et appliqué avec succès le profil(s) pour:"
L["By pressing the Continue button, BenikUI will be applied on your current ElvUI installation.\n\n|cffff8000 TIP: It would be nice if you apply the changes in a new profile, just in case you don't like the result.|r"] = "En appuyant sur le bouton Continuer, BenikUI sera appliqué à votre installation d'ElvUI actuelle.\n\n|cffff8000 CONSEIL: Ce serait bien si vous appliquez les modifications dans un nouveau profil, juste au cas où vous n'aimeriez pas le résultat.|r"
L["This part of the installation process will fill BenikUI datatexts.\n\n|cffff8000This doesn't touch ElvUI datatexts|r"] = "Cette partie du processus d'installation remplira les textes de données de BenikUI.\n\n|cffff8000Cela ne touche pas les textes de données d'ElvUI|r"
L["This part of the installation process will reposition your Unitframes."] = "Cette partie du processus d'installation repositionnera vos cadres d'unité."
L['Actionbars Set'] = "Ensemble des barres d'actions"
L['Addons Set'] = "Ensemble d'addons"
L['BenikUI options are marked with light blue color, inside ElvUI options.'] = "Les options de BenikUI sont marquées de couleur bleu clair, à l'intérieur des options d'ElvUI."
L['Color Theme Set'] = "Ensemble de thème de couleur"
L['Color Themes'] = "Thèmes de couleurs"
L['DataTexts Set'] = "Ensemble des textes de données"
L['Diablo'] = true
L['ElvUI'] = true
L['Hearthstone'] = true
L['Installation'] = true
L['Mists'] = true
L['Please click a button below to apply a color theme.'] = "Veuillez cliquer sur un bouton ci-dessous pour appliquer un thème de couleur."
L['Please click the button below to apply the new layout.'] = "Veuillez cliquer sur le bouton ci-dessous pour appliquer la nouvelle mise en page."
L['Please click a button below to setup your Unitframes.'] = "Veuillez cliquer sur un bouton ci-dessous pour configurer vos cadres d'unité."
L['Please click a button below to setup your actionbars.'] = "Veuillez cliquer sur un bouton ci-dessous pour configurer vos barres d'action."
L['Please click the button below to setup your addons.'] = "Veuillez cliquer sur le bouton ci-dessous pour configurer vos addons."
L['Please click the button below to setup your chat windows.'] = "Veuillez cliquer sur le bouton ci-dessous pour configurer vos fenêtres de discussion."
L['Please click the button below to setup your datatexts.'] = "Veuillez cliquer sur le bouton ci-dessous pour configurer vos textes de date."
L['Setup Addons'] = "Configuration des addons"
L['Setup Layout'] = "Mise en place"
L['This part of the installation process sets up your chat fonts and colors.'] = "Cette partie du processus d'installation configure vos polices et la couleur du chat."
L['This part of the installation process will create and apply profiles for addons like Recount, DBM, ElvUI plugins, etc'] = "Cette partie du processus d'installation créera et appliquera des profils pour des addons tels que Recount, DBM, les plugins d'ElvUI, etc."
L['This part of the installation process will reposition your Actionbars and will enable backdrops'] = "Cette partie du processus d'installation repositionnera vos barres d'action et activera l'arrière-plan"
L['This part of the installation will apply a Color Theme'] = "Cette partie de l'installation appliquera un thème de couleur"
L['This part of the installation will change the default ElvUI look.'] = "Cette partie de l'installation modifiera l'aspect par défaut d'ElvUI."
L['UnitFrames'] = "Cadres d'unité"
L['Unitframes Set'] = "Ensemble de cadres unitaires"
L['Welcome to BenikUI version %s, for ElvUI %s.'] = "Bienvenue dans BenikUI version %s, pour ElvUI %s."
L['Welcome'] = "Bienvenue"
L['You are now finished with the installation process. If you are in need of technical support please visit us at https://www.tukui.org.'] = "Vous avez maintenant terminé le processus d'installation. Si vous avez besoin d'une assistance technique, veuillez nous rendre visite à https://www.tukui.org."

-- actionbar options
L['Bar 1'] = "Barre 1"
L['Bar 2'] = "Barre 2"
L['Choose Actionbar to show to'] = "Choisissez la barre d'action pour l'afficher à"
L['Request Stop button'] = "Bouton de demande d'arrêt"
L['Show in:'] = "Afficher dans"
L['Show small buttons over Actionbar 1 or 2 decoration, to show/hide Actionbars 3 or 5.'] = "Affiche des petits boutons au-dessus de la décoration de la barre d'action 1 ou 2, pour affiche/masque les barres d'action 3 ou 5."
L['Switch Buttons (requires BenikUI Style)'] = "Change les Boutons (nécessite le style BenikUI)"

-- Request stop button
L['LeftClick to Request Stop'] = "Clic gauche pour demander un arrêt"
L['RightClick to Hide'] = "Clic droit pour masquer"

-- afk Mode
L["Logout Timer"] = "Minuterie de déconnexion"
L["Random Stats"] = "Statistiques aléatoires"
L["remaining till level"] = "restant jusqu'au niveau"

-- Dashboards
L['Amount'] = "Montant"
L['Bar Color'] = "Couleur de la barre"
L["Change the Professions Dashboard width."] = "Modifiez la largeur du tableau de bord des professions."
L['Change the System Dashboard width.'] = "Modifiez la largeur du tableau de bord système."
L["Change the Tokens Dashboard width."] = "Modifiez la largeur du tableau de bord des jetons."
L['Choose font for all dashboards.'] = "Choisissez la police pour tous les tableaux de bord."
L['Click :'] = "Clic"
L['Dashboards'] = "tableaux de bord"
L["Enable the Professions Dashboard."] = "Active le tableau de bord des professions."
L['Enable the System Dashboard.'] = "Active le tableau de bord système."
L['Enable the Tokens Dashboard.'] = "Active le tableau de bord des jetons."
L['Enable/Disable'] = "Active/Désactive"
L["Filter Capped"] = "Filtre plafonné"
L['Latency (MS)'] = "Latence (MS)"
L['MouseWheel :'] = "Roulette de la souris :"
L['RightClick :'] = "Clic-droit :"
L['Select Professions'] = "Sélectionn d'une profession"
L['Select System Board'] = "Sélection de la carte système"
L['Select Tokens'] = "Sélection des jetons"
L['Set the font size.'] = "Définissez la taille de la police."
L['Shift+RightClick to remove'] = "Maj + clic droit pour supprimer"
L['Show the token, even if the amount is 0'] = "Affiche le jeton, même si le montant est de 0"
L['Show Weekly max'] = "Afficher le max. hebdomadaire"
L['Show Weekly max tokens instead of total max'] = "Afficher les jetons maximum hebdomadaire au lieu du maximum total"
L['Show zero amount tokens'] = "Afficher les jetons de montant nul"
L['Show/Hide System Dashboard when in combat'] = "Affiche/masque le tableau de bord du système en combat"
L['Show/Hide Tokens Dashboard when in combat'] = "Affiche/masque le tableau de bord des jetons en combat"
L['Show/Hide Tooltips'] = "Affiche/masque les info-bulles"
L['System'] = "Système"
L['Tip: Grayed tokens are not yet discovered'] = "Astuce: les jetons grisés ne sont pas encore découverts"
L['Tip: Click to free memory'] = "Astuce: cliquez pour libérer de la mémoire"
L['Use DataTexts font'] = "Utiliser la police pour les textes de données"
L['Use Faction Colors on Bars'] = true
L['Use Faction Colors on Text'] = true

-- Databars Options
L['Notifiers'] = "Notificateurs"
L['Button Backdrop'] = "Fond de bouton"
L['Without Backdrop'] = "Sans arrière-plan"

-- Skins Options
L['AddOnSkins'] = true
L['AddOns Decor'] = true
L['Choose which addon you wish to be decorated to fit with BenikUI style'] = "Choisissez l'addon que vous souhaitez décorer en fonction du style de BenikUI"
L['ElvUI AddOns'] = true
L['decor.'] = true
L['This will create and apply profile for '] = "Cela créera et appliquera un profil pour"
L['Profiles'] = "Profils"

-- UnitFrame Options
L['Apply shadow under the portrait'] = "Appliquer une ombre sous le portrait"
L['Apply transparency on the portrait backdrop.'] = "Appliquez de la transparence sur le fond du portrait."
L['BenikUI Style on Portrait'] = "BenikUI Style sur Portrait"
L['Castbar Backdrop Color'] = "Couleur de l'arrière-plan de la barre d'incant"
L['Castbar Text'] = "Texte barre d'incant"
L['Change the detached portrait height'] = "Modifier la hauteur du portrait détaché"
L['Change the detached portrait width'] = "Modifier la largeur du portrait détaché"
L['Copy Player portrait width and height'] = "Copier la largeur et la hauteur du portrait du joueur"
L['Detach Portrait'] = "Détacher le portrait"
L['Fix InfoPanel width'] = "Fixer la largeur du panneau d'informations"
L['Health statusbar texture. Applies only on Group Frames'] = "Texture de la barre d'état de santé. S'applique uniquement aux cadres de groupe"
L['Ignore Transparency'] = "Ignore la transparence"
L['Lower InfoPanel width when potraits are enabled.'] = "Largeur inférieure du panneau d'informations lorsque les portraits sont activés."
L['Makes the portrait backdrop transparent'] = "Rend le fond du portrait transparent"
L['Player Size'] = "Taille joueur"
L['Power statusbar texture.'] = "Texture de la barre d'état."
L['Replaces the default role icons with SVUI ones.'] = "Remplace les icônes de rôle par défaut par celles de SVUI."
L['Style Height'] = "Hauteur du style"
L['SVUI Icons'] = true
L['This will ignore ElvUI Health Transparency setting on all Group Frames.'] = "Cela ignorera le paramètre de transparence de la santé ElvUI sur tous les cadres de groupe."
L['Vertical power statusbar'] = "Barre d'état de puissance verticale"

-- Castbar
L['Force show any text placed on the InfoPanel, while casting.'] = "Force l'affichage de tout texte placé sur l'InfoPanel pendant la diffusion."
L['Show Castbar text'] = "Afficher le texte de la barre d'incant"
L['Show InfoPanel text'] = "Afficher le texte du panneau d'informations"
L['Show on Target'] = "Afficher sur la cible"
L['This applies on all available castbars.'] = "Ceci s'applique à toutes les barres d'incantation disponibles."

-- Raid
L['Class Hover'] = true
L['Enable Class color on health border, when mouse over'] = "Active la couleur de classe sur la bordure de santé, lorsque la souris passe dessus"

-- Information
L['Information'] = true
L['Support'] = true
L['Download'] = "Télécharger"
L['Beta versions'] = true
L['Coding'] = true
L['Testing & Inspiration'] = true
L['Donations'] = true
L['My other Addons'] = "Mes autres addons"
L['Discord Server'] = true
L['Git Ticket tracker'] = true
L['Tukui.org'] = true
-- Location Plus
L['Adds player location, coords + 2 Datatexts and a tooltip with info based on player location/level.'] = "Ajoute l'emplacement du joueur, coordonne+2 Textes de données et une info-bulle avec des informations basées sur l'emplacement/le niveau du joueur."
-- Nuts & Bolts
L['ElvUI Nuts & Bolts is a compilation of my addons hosted at tukui.org/Twitch plus some features that are moved from BenikUI'] = true

-- afk
L["Jan"] = true
L["Feb"] = true
L["Mar"] = true
L["Apr"] = true
L["May"] = true
L["Jun"] = true
L["Jul"] = true
L["Aug"] = true
L["Sep"] = true
L["Oct"] = true
L["Nov"] = true
L["Dec"] = true

L["Sun"] = "dimanche"
L["Mon"] = "Lundi"
L["Tue"] = "Mardi"
L["Wed"] = "Mercredi"
L["Thu"] = "Jeudi"
L["Fri"] = "Vendredi"
L["Sat"] = "Samedi"

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
L['Kaliels Tracker'] = true