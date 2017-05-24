%{
###########################################################################
##                                                                       ##
##                                                                       ##
##                       IIIT Hyderabad, India                           ##
##                      Copyright (c) 2015                               ##
##                        All Rights Reserved.                           ##
##                                                                       ##
##  Permission is hereby granted, free of charge, to use and distribute  ##
##  this software and its documentation without restriction, including   ##
##  without limitation the rights to use, copy, modify, merge, publish,  ##
##  distribute, sublicense, and/or sell copies of this work, and to      ##
##  permit persons to whom this work is furnished to do so, subject to   ##
##  the following conditions:                                            ##
##   1. The code must retain the above copyright notice, this list of    ##
##      conditions and the following disclaimer.                         ##
##   2. Any modifications must be clearly marked as such.                ##
##   3. Original authors' names are not deleted.                         ##
##   4. The authors' names are not used to endorse or promote products   ##
##      derived from this software without specific prior written        ##
##      permission.                                                      ##
##                                                                       ##
##  IIIT HYDERABAD AND THE CONTRIBUTORS TO THIS WORK                     ##
##  DISCLAIM ALL WARRANTIES WITH REGARD TO THIS SOFTWARE, INCLUDING      ##
##  ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS, IN NO EVENT   ##
##  SHALL IIIT HYDERABAD NOR THE CONTRIBUTORS BE LIABLE                  ##
##  FOR ANY SPECIAL, INDIRECT OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES    ##
##  WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN   ##
##  AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION,          ##
##  ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF       ##
##  THIS SOFTWARE.                                                       ##
##                                                                       ##
###########################################################################
##                                                                       ##
##          Author :  Sivanand Achanta (sivanand.a@research.iiit.ac.in)  ##
##          Date   :  Jul. 2015                                          ##
##                                                                       ##
###########################################################################
%}

% open error text file
% fid = fopen(strcat(errdir,'/err_',arch_name,'.err'),'w');

GW = gpuArray(W);
Gb = gpuArray(b);

testerr = 0;
% compute error on test set
dnnScores = zeros(test_numbats,dout);
for li = 1:(test_numbats)
    li
    
    sl = test_clv(li+1) - test_clv(li);
    X = gpuArray(test_batchdata(test_clv(li):test_clv(li+1)-1,:));
    Y = test_batchtargets(test_clv(li):test_clv(li+1)-1,:);
    
    % % test error set variables
    ottl = [1 sl*(nl(nlv+1))];
    ottl = cumsum(ottl);
    
    tic
    [ol] = fpav_gpu(X,GW,Gb,nl,f,nh,a_tanh,b_tanh,wtl,btl,sl);
    ol_mat = reshape(ol(1,ottl(end-1):ottl(end)-1),sl,nl(end));
    ol_mat = gather(ol_mat);
    toc
    
    switch cfn
        case 'nll'
            me = compute_zerooneloss_spk(ol_mat,Y,dout);
        case 'ls'
            me = mean(sum((Y - ol_mat).^2,2)./(sum(Y.^2,2)));
    end
    dnnScores(li,:) = mean(ol_mat);
    testerr = testerr + me/test_numbats;
end
dnnScores = dnnScores(:);
% Print error (testing) per epoc
fprintf('Test Loss : %f \n',testerr);


% EER computation
nSpeakers = dout;
nTestChannels = 2;

trials = zeros(nSpeakers*nTestChannels*nSpeakers, 2);
answers = zeros(nSpeakers*nTestChannels*nSpeakers, 1);
for ix = 1 : nSpeakers,
    b = (ix-1)*nSpeakers*nTestChannels + 1;
    e = b + nSpeakers*nTestChannels - 1;
    trials(b:e, :)  = [ix * ones(nSpeakers*nTestChannels, 1), (1:nSpeakers*nTestChannels)'];
    answers((ix-1)*nTestChannels+b : (ix-1)*nTestChannels+b+nTestChannels-1) = 1;
end
imagesc(reshape(dnnScores,nSpeakers*nTestChannels, nSpeakers))
title('Speaker Verification Likelihood (GMM Model)');
ylabel('Test # (Channel x Speaker)'); xlabel('Model #');
colorbar; drawnow; axis xy
figure
eer = compute_eer(dnnScores, answers, true);
eer

save(strcat(resultspath,'dnnScores_',arch_name,'.mat'),'dnnScores','answers','eer');
% fclose(fid);


