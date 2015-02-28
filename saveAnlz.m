% Saves a volume in Analyze format using the mri toolbox.
% The 'par' structure is used to get the [mm] dimensions.
%
% doShiftPlusOne = 1 brings the values from a range of
% [0..255] to [1..255]. This  is useful if the '0' is assigned
% a special meaning later, e.g. for masking.

function saveAnlz(im,par,fname,doShiftPlusOne,mode)

nSlices = size(im,3);

% build the Analyze header
avwout = avw_hdr_make;

if mode==2
    avwout.hdr.dime.dim(2) = nSlices;
    avwout.hdr.dime.dim(3) = size(im,2);
    avwout.hdr.dime.pixdim(1) = 4; % ???
    avwout.hdr.dime.pixdim(2) = par.thickness;
    avwout.hdr.dime.pixdim(3) = par.inplane;
    avwout.hdr.dime.pixdim(4) = par.inplane;
    avwout.hdr.dime.pixdim(5) = 1; %ms ???
    avwout.hdr.dime.dim(4)    = size(im,1);
    
elseif mode ==3


    avwout.hdr.dime.dim(2) = size(im,2);
    avwout.hdr.dime.dim(3) = size(im,1);
    avwout.hdr.dime.pixdim(1) = 4; % ???
    avwout.hdr.dime.pixdim(2) = par.inplane;
    avwout.hdr.dime.pixdim(3) = par.inplane;
    avwout.hdr.dime.pixdim(4) = par.thickness;
    avwout.hdr.dime.pixdim(5) = 1; %ms ???
    avwout.hdr.dime.dim(4)    = nSlices;

end

% the following two fields are not correctly set by avw_hdr_make
% so we set something useful by hand
avwout.hdr.hist.originator = [0 128 0 128 0 91 0 0 0 0];
avwout.hdr.hist.exp_time   = [0 0 0 0 0 0 0 0 0 0];

avwout.hdr.dime.datatype = 4; % signed short ( 16 bits per voxel )

% brute force adjustment of the range
ma = max(max(max(im)));
mi = min(min(min(im)));
disp(sprintf('range before limitation: [%f..%f]',mi,ma))

%%%% limitation %%%%%%%%
im = limitVals(im,0,255);

if doShiftPlusOne
  disp('values are shifted from [0..255] to [1..255]');
  im = im + 1;
  if ~isempty(find(im > 255))
    disp('some new values of 256 were limited to 255');
    im(find(im > 255)) = 255;
  end
end

ma = max(max(max(im)));
mi = min(min(min(im)));
disp(sprintf('range after limitation: [%f..%f]',mi,ma))

% 2D image is a special case
if (nSlices==1)
  avwout.img = uint16(permute(im,[2 1]));
else
    if mode ==3
        avwout.img = flipdim(permute(im,[2 1 3]),3);
    end
    if mode ==2
        avwout.img = permute(im,[3 2 1]);
        avwout.img = flip(avwout.img,1);
        avwout.img = flip(avwout.img,2);
        avwout.img = flip(avwout.img,3);
    end

end

% save using the toolbox

 avw_img_write(avwout,fname,mode); % 3 = sagittal
