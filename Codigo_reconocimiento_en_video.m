clc;
close all;
clear;
vidObj = VideoWriter('Vidfinal.mp4');%iniciar objeto de grabación
%Leer imagen de fondo
Fondo=imread('fondopruebafinal.jpg');
Fondo=imresize(Fondo,0.5);
Fondo=imgaussfilt(Fondo,1);%Suavizado
%Lectura de video
movieObj = VideoReader('videopruebafinal.mp4');
get(movieObj) 
nFrames = movieObj.NumberOfFrames;
%Read Current Frame
open(vidObj);
fig=figure;
for iFrame=1:nFrames
count=0;%iniciar conteo de personas en 0
Frame= read(movieObj,iFrame);
Frame=imresize(Frame,0.5);
%Convertir RGB a escala de grises
Fondo_gr=rgb2gray(Fondo);
Frame_gr=rgb2gray(Frame);
Frame_gr=imgaussfilt(Frame_gr,1);%Suavizado
Out = imabsdiff(Fondo_gr,Frame_gr);%Sustraccion de fondo
Filtrada = medfilt2(Out,[7 7]);%Filtrado para reducción de ruido
%Converrsión a binaria
umbral=0.18;
S=strel('disk',	21);
Binaria = imbinarize(Filtrada,umbral);
Binaria=imdilate(Binaria,S);
Binaria=imfill(Binaria,'holes');
[L ,num]=bwlabel(Binaria);  %Detectar objetos
STATS=regionprops(L,'all');
imshow(Frame)
for k=1:length(STATS)


if STATS(k).Area>20000 
 rectangle('Position', STATS(k).BoundingBox, 'EdgeColor', 'b','LineWidth',2);
 count= count + 1;
end
end
title(['Personas detectadas:', num2str(count)] )
pause(0.01)
newFrameOut = getframe(fig);
writeVideo(vidObj,newFrameOut);
end
close(vidObj);
