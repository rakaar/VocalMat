function astrctReliableFrames = fnFindReliable(strctMovieInfo, ...
                                               strctAdditionalInfo, ...
                                               iNumMice, ...
                                               iStartFrame, ...
                                               iEndFrame, ...
                                               iMinInterval, ...
                                               iSkip, ...
                                               iNumReinitializations, ...
                                               iMaxJobSize, ...  
                                               iNumFramesMissing, ...
                                               handles)  %#ok

fprintf('Setting inital ellipses for all jobs\n');
fnLog('In fnFindReliable');
iCurrFrame = iStartFrame;
iCounter = 1;
%iLastReliable = iStartFrame;

while iCurrFrame < iEndFrame %strctMovieInfo.m_iNumFrames
  fprintf('Setting ellipses at frame %d\n',iCurrFrame);
  a2iFrame = fnReadFrameFromVideo(strctMovieInfo,iCurrFrame);
  a2fFrame = double(a2iFrame)/255;
  fnLog(['Calling fnRiskyInit2 for frame ' num2str(iCurrFrame)], ...
        2, ...
        a2fFrame);
  [bFailed, acReliableEllipses] = ...
    fnRiskyInit2(a2iFrame, ...
                 strctAdditionalInfo, ...
                 iNumMice, ...
                 iNumReinitializations, ...
                 true);  %,iCurrFrame);
  if bFailed && isempty(acReliableEllipses)
    iCurrFrame = iCurrFrame + iSkip;
    continue;
  end;
  for iSetIter=1:length(acReliableEllipses)
    astrctReliableEllipses = acReliableEllipses{iSetIter};
    
    a3iRectified = fnCollectRectifiedMice(a2iFrame, ...
                                          astrctReliableEllipses);
    iNumMice = length(astrctReliableEllipses);
    a2fProb = zeros(iNumMice,iNumMice);
    a2fProbFlip = zeros(iNumMice,iNumMice);
    for iMouseIter=1:iNumMice
      % Apply identity classifiers on image patch
      iNumBins=strctAdditionalInfo.m_strctMiceIdentityClassifier.iNumBins;
      Tmp = fnHOGfeatures(a3iRectified(:,:,iMouseIter),iNumBins);
      afFeatures = Tmp(:);
      
      for iClassifierIter=1:iNumMice
        strctMiceIdentityClassifier= ...
          strctAdditionalInfo.m_strctMiceIdentityClassifier;
        strctClassifierThis= ...
          strctMiceIdentityClassifier.m_astrctClassifiers(iClassifierIter);
        a2fProb(iMouseIter,iClassifierIter) =...
          fnApplyTDist(strctClassifierThis, afFeatures');
      end
      % Apply identity classifiers on flipped image patch
      Tmp = fnHOGfeatures(a3iRectified(end:-1:1,end:-1:1,iMouseIter), ...
                          iNumBins);
      afFeatures = Tmp(:);
      for iClassifierIter=1:iNumMice
        strctMiceIdentityClassifier= ...
          strctAdditionalInfo.m_strctMiceIdentityClassifier;
        strctClassifierThis= ...
          strctMiceIdentityClassifier.m_astrctClassifiers(iClassifierIter);
        a2fProbFlip(iMouseIter,iClassifierIter) =...
          fnApplyTDist(strctClassifierThis, afFeatures');
      end
    end
    a2fProbHT = max(a2fProbFlip,a2fProb);
    % a2fProbHT  contains:
    % [P(x1 | Id1), Pr(x1 | Id2), ...
    % [P(x2 | Id1), Pr(x2 | Id2), ...
    %
    % Now we convert this to Pr(ID_i|X_j) using Pr(Id_i|X_j) = 
    %   Pr(X_j|Id_i) /  [Pr(x_j|Id1)+Pr(x_j|Id2)+Pr(x|Id3)+Pr(x|Id4)]
    a2fProbID = a2fProbHT ./ repmat(sum(a2fProbHT,2), 1,iNumMice);
    % Now, we take MAP estimate of a2fProbID
    % a2fProbID is : [P(Id1|x1) P(Id2 | x1) P(ID3|x1)...
    %                [P(Id1|x2) P(Id2 | X2) ....
    
    [afConfidence,aiIdentities]=max(a2fProbID,[],2);
    bReliableIdentities = ...
      all(afConfidence > 0.6) & all(sort(aiIdentities)' == 1:iNumMice);
    if bReliableIdentities
      strctAdditionalInfo.strctBackground.m_a2fMedian = ...
        fnUpdateBackground(a2iFrame, ...
                           strctAdditionalInfo.strctBackground.m_a2fMedian, ...
                           astrctReliableEllipses, ...
                           1/2);
      fnLog('Super Reliable Frame. Updating Background!', ...
            2, ...
            uint8(strctAdditionalInfo.strctBackground.m_a2fMedian*255));
    end
    
    %%
    %     if iCurrFrame-iLastReliable >= iMaxJobSize
    %         fprintf(['Forcing key frame because job size exceeded ' ...
    %                  '%d frames\n'], ...
    %                 iMaxJobSize);
    %     end
    %
    %     if bFailed && iCurrFrame-iLastReliable < iMaxJobSize
    %         fprintf('Not Reliable!\n');
    %         iCurrFrame = iCurrFrame + iSkip;
    %         continue;
    %     end;
    %     fprintf('Reliable!\n');
    %     [bReliable, astrctReliableEllipses] = ...
    %         fnIsReliableFrame(a2fFrame, ...
    %                           strctAdditionalInfo, ...
    %                           iNumMice, ...
    %                           false);
    %     if ~bReliable
    %         [bFailed, astrctReliableEllipses] = ...
    %             fnRiskyInit2(a2iFrame, ...
    %                          strctAdditionalInfo, ...
    %                          iNumMice, ...
    %                          iNumReinitializations);
    %         if bFailed
    %             iCurrFrame = iCurrFrame + iSkip;
    %            continue;
    %         end;
    %     end;
    
    %iLastReliable = iCurrFrame;
    strctReliable.m_iFrame = iCurrFrame;
    strctReliable.m_bValid = true;
    strctReliable.m_bBigJump = false;
    strctReliable.m_astrctEllipse = astrctReliableEllipses;
    strctReliable.m_a2iBackground = ...
      uint8(strctAdditionalInfo.strctBackground.m_a2fMedian*255);
    astrctReliableFrames(iCounter) = strctReliable;  %#ok
    iCounter=iCounter+1;
    
    if ~isempty(handles)
      hold off;
      cla;
      a3fTmp(:,:,1)=a2fFrame;
      a3fTmp(:,:,2)=a2fFrame;
      a3fTmp(:,:,3)=a2fFrame;
      image([], [], a3fTmp, ...
            'BusyAction', 'cancel', ...
            'Parent', handles.axes1, ...
            'Interruptible', 'off');
      hold on;
      %ahHandles = fnDrawTrackers(astrctReliableEllipses);
      fnDrawTrackers(astrctReliableEllipses);
      set(handles.text1, 'String',sprintf('Frame %d',iCurrFrame));
      axis ij;
      drawnow;
    end;
    
  end;
  iCurrFrame = iCurrFrame + iMinInterval;
end;
astrctReliableFrames = ...
  fnAddBigJumpsToReliableFrames(handles, ...
                                strctAdditionalInfo, ...
                                strctMovieInfo, ...
                                astrctReliableFrames, ...
                                iNumMice, ...
                                iNumReinitializations, ...
                                iStartFrame, ...
                                iEndFrame, ...
                                iNumFramesMissing);
fprintf('Done!\n');

end