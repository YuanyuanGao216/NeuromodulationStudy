function MeanHbMatrix = delete_unskilled_fNIRS(MeanHbMatrix,delete_unskilled)

if delete_unskilled == 1
%     MeanHbMatrix.Train(2,1,:,:,:,:) = nan;
    MeanHbMatrix.Train(1,1,:,:,:,:) = nan;
    MeanHbMatrix.Train(1,2,:,:,:,:) = nan;
%     MeanHbMatrix.Train(2,6,:,:,:,:) = nan;
    
%     MeanHbMatrix.Follow(2,1,:,:,:,:) = nan;
    MeanHbMatrix.Follow(1,1,:,:,:,:) = nan;
    MeanHbMatrix.Follow(1,2,:,:,:,:) = nan;
%     MeanHbMatrix.Follow(2,6,:,:,:,:) = nan;
    
%     MeanHbMatrix.Transfer(2,1,:,:,:,:) = nan;
    MeanHbMatrix.Transfer(1,1,:,:,:,:) = nan;
    MeanHbMatrix.Transfer(1,2,:,:,:,:) = nan;
%     MeanHbMatrix.Transfer(2,6,:,:,:,:) = nan;    
end