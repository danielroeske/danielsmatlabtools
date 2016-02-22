function [image,map,transparent]=transparentGifRead(filename)
%TRANSPARENTGIFREAD reads GIF files maintaining the transparency.
%   [IMAGE, MAP, TRANSPARENT] = TRANSPARENTGIFREAD(FILENAME) returns a gif
%   file.
%   IMAGE - Stacked indexed image (uint8)
%   MAP - Colormap
%   TRANSPARENT - Index in image used for transparent pixels
%
%   Please not the offset of 1 between colormap and unsigned integer
%   images. Example code to replace transparency with green:
%   
%   [stack,map,transparent]=transparentGifRead('tr.gif');
%   map(transparent+1,:)=[0,1,0] %offset 1 because uint8 starts at 0 but indices at 1
%   for frame=1:size(stack,ndims(stack))
%    imshow(stack(:,:,frame),map);
%    pause(1/25);
%   end
%
%   Known issues: Function is not compartible to OCTAVE   
%
%   Author Daniel Roeske <danielroeske.de>
%
%   See also IMREAD, IMFINFO.

if ~exist(filename,'file')
    error('file %s does not exist',filename);
end
info=imfinfo(filename);
ColorTable={'ColorTable','Colormap'}; %Different names on OCTAVE and MATLAB
ColorTable=ColorTable{cellfun(@(x)isfield(info,x),ColorTable)};

%Check if color map for all frames is the same
if any(any(any(diff(cat(3,info.(ColorTable)),[],3))))
    error('inconsistent color map')
else
    map=info(1).(ColorTable);
end
if nargout==3
  %Check if transparent color for all frames is the same
  if any(diff([info.TransparentColor]))
      error('inconsistent transparency information')
  else
      transparent=info(1).TransparentColor-1;
  end
end
str = javax.imageio.ImageIO.createImageInputStream(java.io.File(filename));
t = javax.imageio.ImageIO.getImageReaders(str);
reader = t.next();
reader.setInput(str);
numframes = reader.getNumImages(true);
for imageix = 1:numframes
    data = reader.read(imageix-1).getData();
    height = data.getHeight();
    width = data.getWidth();
    data2 = reader.read(imageix-1).getData().getPixels(0,0,width,height,[]);
    if imageix == 1
        image=zeros(height,width,1,numframes,'uint8');
    end
    %row major vs column major fix
    image(:,:,1,imageix) = reshape(data2,[width height]).';%'
end
str.close();
end