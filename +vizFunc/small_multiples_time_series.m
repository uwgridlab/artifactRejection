function small_multiples_time_series(signal,t,varargin)
% DJC - 2-18-2018 - small multiples plot for visualizing the results
% time x channels x trials
% options for 'modePlot' include 'avg,'ind,'confInt'
% 'avg' = average of time x channels x trials
% 'ind' = plot each trial individually
% 'confInt' = plot a 95% confidence interval of values around the mean 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% get inputs
p = inputParser;

addRequired(p,'signal',@isnumeric);
addRequired(p,'t',@isnumeric);

addParameter(p,'type1',[],@isnumeric);
addParameter(p,'type2',[],@isnumeric);
addParameter(p,'newFig',1,@(x) x==0 || x ==1)
addParameter(p,'xlims',[-200 1000],@isnumeric);
addParameter(p,'ylims',[-0.8 0.8],@isnumeric);
addParameter(p,'highlightRange',[],@isnumeric);
addParameter(p,'modePlot','avg',@isstr)

p.parse(signal,t,varargin{:});

signal = p.Results.signal;
t = p.Results.t;
type1 = p.Results.type1;
type2 = p.Results.type2;
newFig = p.Results.newFig;
xlims = p.Results.xlims;
ylims = p.Results.ylims;
highlightRange = p.Results.highlightRange;
modePlot = p.Results.modePlot;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% define new figure
if newFig
    totalFig = figure;
    totalFig.Units = 'inches';
    totalFig.Position = [1 1 8 8];
    CT = vizFunc.cbrewer('qual','Accent',8);
    CT = flipud(CT);
else
    gcf;
    hold on
    CT = vizFunc.cbrewer('qual','Accent',8);
    CT = flipud(CT);
    CT(1,:) = CT(4,:);
end


% determine number of subplots using subplots helper function
p = vizFunc.numSubplots(size(signal,2));

nullSig = zeros(length(t),1);

if strcmp(modePlot,'avg')
    signal = nanmean(signal,3);
    
end

for idx=1:size(signal,2)
    %smplot(p(1),p(2),idx,'axis','on')
    plt_sub = vizFunc.smplot(p(1),p(2),idx,'axis','on');
    switch modePlot
        case 'avg'
            if ismember(idx,type1)
                plot(1e3*t,nullSig,'Color',CT(3,:),'LineWidth',2)
                title([num2str(idx)],'Color',CT(3,:))
            elseif ismember(idx,type2)
                plot(1e3*t,1e3*signal(:,idx),'Color',CT(2,:),'LineWidth',2)
                title([num2str(idx)],'Color',CT(2,:))
            else
                plot(1e3*t,1e3*signal(:,idx),'Color',[204 85 0]/255,'LineWidth',2)
                title([num2str(idx)],'color','k')
            end
            
        case 'ind'
            if ismember(idx,type1)
                plot(1e3*t,nullSig,'Color',CT(3,:),'LineWidth',2)
                title([num2str(idx)],'Color',CT(3,:))
            elseif ismember(idx,type2)
                plot(1e3*t,1e3*squeeze(signal(:,idx)),'Color',CT(2,:),'LineWidth',2)
                title([num2str(idx)],'Color',CT(2,:))
            else
                plot(1e3*t,1e3*squeeze(signal(:,idx)),'color',[204 85 0]/255,'LineWidth',2)
                title([num2str(idx)],'color','k')
            end
            
        case 'confInt'
            if ismember(idx,type1)
                plot(1e3*t,nullSig,'Color',CT(3,:),'LineWidth',2)
                title([num2str(idx)],'Color',CT(3,:))
            elseif ismember(idx,type2)
                vizFunc.plot_error(1e3*t',1e3*squeeze(signal(:,idx,:)),'CI',CT(2,:));
                title([num2str(idx)],'Color',CT(2,:))
            else
                vizFunc.plot_error(1e3*t'',1e3*squeeze(signal(:,idx,:)),'CI',CT(1,:));
                title([num2str(idx)],'color','k')
            end
    end
   
    axis off
    axis tight
    %xlim([-10 200])
    xlim(xlims)
    
    ylim(ylims)
    vizFunc.vline(0)
    
    if ~isempty(highlightRange)
       %hColor = [116/255 255/255 112/255];
         hColor = [0.5 0.5 0.5];

        y_range = ([-150 150]);
        vizFunc.highlight(plt_sub, highlightRange, y_range, hColor);
    end
    
end
%%
obj = vizFunc.scalebar;
obj.XLen = 500;              %X-Length, 10.
obj.XUnit = 'ms';            %X-Unit, 'm'.
obj.YLen = 1;
obj.YUnit = 'mV';

obj.Position = [0 0];
obj.hTextX_Pos = [5,-0.2]; %move only the LABEL position
obj.hTextY_Pos =  [-150 0];
obj.hLineY(2).LineWidth = 5;
obj.hLineY(1).LineWidth = 5;
obj.hLineX(2).LineWidth = 5;
obj.hLineX(1).LineWidth = 5;
obj.Border = 'LL';          %'LL'(default), 'LR', 'UL', 'UR'

end