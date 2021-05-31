clc;
close all;
clear;
%Leer imagen de fondo
Fondo=imread('fondopruebafinal.jpg');
Fondo=imresize(Fondo,0.5);%Redimensionar la imagen
Fondo=imgaussfilt(Fondo,1);%Suavizado
%Lectura de video
movieObj = VideoReader('videopruebafinal.mp4'); 
get(movieObj) 
nFrames = movieObj.NumberOfFrames;
%Leer Frame
Frame=read(movieObj,68);
Frame=imresize(Frame,0.5);%Redimensionar la imagen
%Mostrar fondo y frame
subplot(2,2,1);imshow(Fondo);title('Fondo');
subplot(2,2,2);imshow(Frame);title('Frame actual');
%Convertir RGB a escala de grises
Fondo_gr=rgb2gray(Fondo);
Frame_gr=rgb2gray(Frame);
Frame_gr=imgaussfilt(Frame_gr,1);%suavizado
%Sustraccion de fondo
Out = imabsdiff(Fondo_gr,Frame_gr);
Filtrada=medfilt2(Out,[7 7]);%Filtrado para reducción de ruido
%Converrsión a binaria
umbral=0.18;
Binaria = imbinarize(Filtrada,umbral);
S=strel('disk',	21);
Binaria=imdilate(Binaria,S);
Binaria=imfill(Binaria,'holes');
[L ,num]=bwlabel(Binaria);  %Detectar objetos
STATS=regionprops(L,'all');
% Trazar siluetas
[B,L,N,A] = bwboundaries(L);
subplot(2,2,3),  imshow(L);title('Imagen binaria');
subplot(2,2,4),  imshow(L);title('Silueta detectada');
hold on;
for k=1:length(B)
if(~sum(A(k,:)))
boundary = B{k};
plot(boundary(:,2), boundary(:,1), 'r','LineWidth',2);%Dibujar siluetas
if STATS(k).Area>20000
rectangle('Position', STATS(k).BoundingBox, 'EdgeColor', '#0078FF','LineWidth',2);%Dibujar cuadro de detección
end
end
end
