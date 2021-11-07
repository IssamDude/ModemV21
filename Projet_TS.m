close all

load('DonneesBinome5.mat');
x = bits;

% Déclaration des constantes
    % Fréquences 
f0 = 6000;
f1 = 2000;
fc = 4000;
Fe = 48000;
Te = 1/Fe;

    % Longueur 
n = length(x);
    
    % Phases
phi0 = rand*2*pi;
phi1 = rand*2*pi;

    % Ts et Ns
Bits_par_sec = 300;
Ns = floor(Fe/Bits_par_sec);
Ts = Ns/Fe;

    % Intervalle de temps
t = [0:Te:(n*Ns-1)*Te];

    % Intervalle fréquence
f = [0:Fe/(length(x)*Ns):Fe-1/(length(x)*Ns)];


% Constitution de NRZ et sa longueur
NRZ = repelem(x, Ns);
N = length(NRZ);

% Signal modulé en fréquence 
cosf0 = cos(2*pi*f0*t + phi0);
cosf1 = cos(2*pi*f1*t + phi1);
X = (1 - NRZ).*cosf0 + NRZ.*cosf1;


% Bruit blanc gaussien 
Px = mean( abs(X).^2 );
Pb = Px / (10^(1));
bruit = sqrt(Pb)*randn(1,N);


% Signal bruité
S_bruite = X + bruit;


% Implantation filtre passe_bas

Ordre = 601;
fc_N = fc/Fe;
    
    % Réponse fréquentielle
h1 = 2*fc_N*sinc(2*fc*[-(Ordre-1)/2*Te:Te:(Ordre-1)/2*Te]);

% Implantation filtre passe_haut
   
    % Réponse fréquentielle
h2 = - h1;
h2((Ordre+1)/2) = 1 - 2*fc_N;


% Filtrage (en prenant en considération le retard)
S_bruite1 = [ S_bruite, zeros(1,(Ordre-1)/2)];

S_filtre_1 = filter(h1, 1, S_bruite1);
S_filtre_1 = S_filtre_1((Ordre+1)/2:end);

S_filtre_2 = filter(h2, 1, S_bruite1);
S_filtre_2 = S_filtre_2((Ordre+1)/2:end);


% Détection de l'énergie
Energie1 = reshape(S_filtre_1, Ns, length(S_filtre_1)/Ns);
Energie_Vecteur = sum(Energie1.^2);
    % K comme étant la moyenne du vecteur d'énergie
K = mean(Energie_Vecteur);

% Récupération signal 
S_recupere = Energie_Vecteur > K;

% Taux erreur
Taux_erreur = 1 - length(find(S_recupere == x))/n;

% Affichage des tracées 
Traces(Fe, Ordre, t, f, x, NRZ, X, bruit, S_bruite, h1, h2, S_filtre_1, Energie_Vecteur, S_recupere);

% Affichage image 
pcode reconstitution_image;
reconstitution_image(S_recupere);
which reconstitution_image;




% Démodulateur FSK
    % Introduction d'une différence de phase 
phi00 = rand*2*pi;
phi11 = rand*2*pi;
cosf0 = cos(2*pi*f0*t + phi00);
cosf1 = cos(2*pi*f1*t + phi11);
    
    % Implantation du démodulateur
X0 = X.*cosf0;
X1 = X.*cosf1;
X0 = sum(reshape(X0, Ns, []));
X1 = sum(reshape(X1, Ns, []));

    % Restitution des bits
bit_restitue = (X1 - X0) > 0;
Taux_erreur_1 = 1 - length(find(bit_restitue == x))/n;
pcode reconstitution_image;
reconstitution_image(bit_restitue);
which reconstitution_image;


% Démodulateur FSK avec gestion de synchronisation

    % Implantation de la deuxième solution du modem FSK
X0_cos = X.*cos(2*pi*f0*t);
X0_sin = X.*sin(2*pi*f0*t);
X1_cos = X.*cos(2*pi*f1*t);
X1_sin = X.*sin(2*pi*f1*t);
X0_cos = sum(reshape(X0_cos, Ns, []));
X0_sin = sum(reshape(X0_sin, Ns, []));
X1_cos = sum(reshape(X1_cos, Ns, []));
X1_sin = sum(reshape(X1_sin, Ns, []));


    % restitution des bits
bit_restitue_2 = (X1_sin.^2 + X1_cos.^2) - (X0_cos.^2 + X0_sin.^2) > 0;
Taux_erreur_2 = 1 - length(find(bit_restitue_2 == x))/n;
pcode reconstitution_image;
reconstitution_image(bit_restitue_2);
which reconstitution_image;








