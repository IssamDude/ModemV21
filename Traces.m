function [] = Traces(Fe, Ordre, t, f, x, NRZ, X, bruit, S_bruite, h1, h2, S_filtre_1, Energie_Vecteur, S_recupere)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

    N = length(X);
    DSP_X = ((abs(fft(X))).^2)/N;
    DSP_NRZ = ((abs(fft(NRZ))).^2)/N;
    DSP_S_FILTRE = ((abs(fft(S_filtre_1))).^2)/N;
    
    % Tracé NRZ
    figure()
    subplot(2, 2 ,1)
    plot(t, NRZ, 'b')
    title('Signal NRZ(t)')
    xlabel('temps (s)')
    ylabel('NRZ(t)')
    subplot(2, 2, 2)
    semilogy(0:Fe/N:Fe-1/N, DSP_NRZ)
    title('DSP de NRZ')
    xlabel('frequence (Hz)')
    ylabel('DSP(f)de NRZ')
    
    % Tracé du signal modulé X
    subplot(2, 2 ,3)
    plot(t, X, 'b')
    title('Signal module X(t)')
    xlabel('temps (s)')
    ylabel('X(t)')
    subplot(2, 2, 4)
    semilogy(0:Fe/N:Fe-1/N, DSP_X)
    title('DSP de signal module X')
    xlabel('frequence (Hz)')
    ylabel('DSP(f) de X')
    
    % Tracé du bruit et signal bruité
    figure()
    subplot(2, 2 ,1)
    plot(t, X, 'b')
    title('Signal module X(t)')
    xlabel('temps (s)')
    ylabel('X(t)')
    subplot(2, 2, 2)
    plot(t, bruit)
    title('bruit(t)')
    xlabel('temps (s)')
    ylabel('bruit(t)')
    subplot(2, 2, 3)
    plot(t, S_bruite)
    title('Signal Bruite Sbruite(t)')
    xlabel('temps (s)')
    ylabel('Signal bruite Sbruit(t)')
    
    % Tracé des réponses impulsionnelles et fréquentielles des filtres implantées 
    Te = 1/Fe;
    figure()
    subplot(2, 2, 1)
    plot([-(Ordre-1)/2*Te:Te:(Ordre-1)/2*Te], h1)
    title('Reponse impulsionnelle du filtre passe-bas h1(k)')
    xlabel('k')
    ylabel('h1(k)')
    subplot(2, 2, 2)
    plot(linspace(-Fe/2,Fe/2,Ordre),fftshift(abs(fft(h1))))
    title('Reponse frequetielle du filtre passe-bas')
    xlabel('frequence (Hz)')
    ylabel('Reponse frequetielle passe-bas')
    subplot(2, 2, 3)
    plot([-(Ordre-1)/2*Te:Te:(Ordre-1)/2*Te], h2)
    title('Reponse impulsionnelle du filtre passe-haut h2(k)')
    xlabel('k')
    ylabel('h2(k)')
    subplot(2, 2, 4)
    plot(linspace(-Fe/2,Fe/2,Ordre),fftshift(abs(fft(h2))))
    title('Reponse frequetielle du filtre passe-haut')
    xlabel('fréquence (Hz)')
    ylabel('Réponse frequetielle passe-haut')
    
    % Tracé de la dsp du signal modulé en fréquence X(t) et les réponses en
    % fréquence des filtres implantés
    % On travaillera après avec le filtre passe-bas !
    figure()
    subplot(2, 1, 1)
    semilogy(0:Fe/N:Fe-1/N,DSP_X);
    hold on 
    semilogy(0:Fe/N:Fe-1/N, abs(fft(h1,N)))
    title('Trace de la dsp du signal modulé en fréquence X(t) et la réponse en fréquence du filtre passe-bas')
    xlabel('frequence (Hz)')
    ylabel('Tracees')
    legend('DSP X(t)', 'Reponse en frequence passe-bas')
    subplot(2, 1, 2)
    semilogy(0:Fe/N:Fe-1/N,DSP_X);
    hold on 
    semilogy(0:Fe/N:Fe-1/N, abs(fft(h2,N)))
    title('Trace de la dsp du signal modulé en fréquence X(t) et la reponse en frequence du filtre passe-haut')
    xlabel('frequence (Hz)')
    ylabel('Tracées')
    legend('DSP X(t)', 'Reponse en frequence passe-haut')
    
    % Tracé du signal après filtrage et sa dsp
    figure()
    subplot(2, 2, 1)
    plot(t, S_filtre_1)
    title('Signal filtre Sfiltre1(t)')
    xlabel('temps (s)')
    ylabel('S_filtre_1(t)')
    subplot(2, 2, 2)
    semilogy(0:Fe/N:Fe-1/N, DSP_S_FILTRE)
    title('DSP du Signal filtre Sfiltre1(t)')
    xlabel('fréquence (Hz)')
    ylabel('DSP(f)')
    
end

