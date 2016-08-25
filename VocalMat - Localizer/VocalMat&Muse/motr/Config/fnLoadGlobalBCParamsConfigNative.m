function s=fnLoadGlobalBCParamsConfigNative()

s=struct('Boosting',{struct('iGapLength',{4}, ...
                            'bRandomNegative',{1}, ...
                            'iMaxNrounds',{50}, ...
                            'fNegPosRatio',{1}, ...
                            'fImpvovementInc',{0.005}, ...
                            'fImprovementInc',{0.005}, ...
                            'fLookNoFurtherError',{0.001}, ...
                            'iMaxMissRate',{0.1}, ...
                            'iMaxIterations',{0}, ...
                            'bNegativeSandwich',{1}, ...
                            'fMaxMissRate',{0}, ...
                            'fWeightScheme',{0.064516}, ...
                            'fPosNegWeight',{0.032258})},...
         'Features',{struct('bMouseFrame',{0}, ...
                            'bDistances',{1}, ...
                            'aTimeScales',{3}, ...
                            'bMousePair',{1}, ...
                            'bCoordinates',{0}, ...
                            'iSelfTimeScale',{1}, ...
                            'iTimeScale',{1}, ...
                            'strctOtherBehaviors',...
                                {struct('Doing_Nothing',{struct('bElapsedFrames',{false},'bFrequency',{false},'iFreqTimeScale',{zeros(0,0)})}, ...
                                        'Running',{struct('bElapsedFrames',{false},'bFrequency',{false},'iFreqTimeScale',{zeros(0,0)})}, ...
                                        'Approaching',{struct('bElapsedFrames',{0},'bFrequency',{false},'iFreqTimeScale',{zeros(0,0)})}, ...
                                        'Following',{struct('bElapsedFrames',{false},'bFrequency',{false},'iFreqTimeScale',{zeros(0,0)})}, ...
                                        'Head_Sniffing',{struct('bElapsedFrames',{false},'bFrequency',{false},'iFreqTimeScale',{zeros(0,0)})}, ...
                                        'Tail_Sniffing',{struct('bElapsedFrames',{false},'bFrequency',{false},'iFreqTimeScale',{zeros(0,0)})}, ...
                                        'Fighting',{struct('bElapsedFrames',{false},'bFrequency',{false},'iFreqTimeScale',{zeros(0,0)})}, ...
                                        'Eating',{struct('bElapsedFrames',{false},'bFrequency',{false},'iFreqTimeScale',{zeros(0,0)})}, ...
                                        'Drinking',{struct('bElapsedFrames',{false},'bFrequency',{false},'iFreqTimeScale',{zeros(0,0)})}, ...
                                        'Sleeping',{struct('bElapsedFrames',{false},'bFrequency',{false},'iFreqTimeScale',{zeros(0,0)})}, ...
                                        'Digging',{struct('bElapsedFrames',{false},'bFrequency',{false},'iFreqTimeScale',{zeros(0,0)})}, ...
                                        'Mating',{struct('bElapsedFrames',{false},'bFrequency',{false},'iFreqTimeScale',{zeros(0,0)})})}, ...
                            'bCdiff',{false}, ...
                            'bDdiff',{1}, ...
                            'bThresholdLike',{true}, ...
                            'fWeightScheme',{0.5})},...
         'MousePOIs',{{struct('aPointsNum',{[1 1]},'aNormRadii',{[1 0]},'aTheta',{[0 0]}) ...
                       struct('aPointsNum',{[1 1]},'aNormRadii',{[1 0]},'aTheta',{[3.14159265358979 3.14159265358979]})}},...
         'FramePOIs',{struct('aX',{zeros(0,0)},'aY',{zeros(0,0)})},...
         'Filters',{struct('iMaxDistance',{10000}, ...
                           'iMinDistance',{0}, ...
                           'fMinRelativeSpeed',{-10000}, ...
                           'fMaxRelativeSpeed',{10000}, ...
                           'fMaxMouse2Speed',{10000}, ...
                           'fMaxMouse1Speed',{10000}, ...
                           'fMinMouse1Speed',{0}, ...
                           'fMinMouse2Speed',{0})},...
         'sBehaviorType',{'Mating'},...
         'aiIntervals',{[1 7000;40000 44000]});
     
end
