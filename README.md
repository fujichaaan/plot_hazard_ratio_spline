# plot_hazard_ratio_spline 📊
This page summarizes data visualization for time-to-event analysis with an exposure with natural spline function

----------------------------------- + 

🚨 R CODE FOR THIS PAGE IS <b><a href="https://github.com/fujichaaan/plot_hazard_ratio_spline/blob/main/plot_rcs_cph.R">HERE</a></b>

----------------------------------- + 

## Original dataset and plots
Original codes are derived from the page for plotHR function below. Please check <a href="https://www.imsbio.co.jp/RGM/R_rdfile?f=Greg/man/plotHR.Rd&d=R_CC">here</a>

<br>

![image](https://user-images.githubusercontent.com/19466700/223549734-6a16341e-2b1c-433d-80d0-c776fcd4e5ce.png)

<br>

## 1. Same plot in ggplot2
Using the cph and Predict functions, we can estimate hazard ratio and summrise the results as a table with confidence intervals.

<br>

![image](https://user-images.githubusercontent.com/19466700/223553647-e893407e-64ad-49f3-b3bd-3ae12881f51d.png)

<br>

## 2. Changes the knots (same number, different points)
The default setting for knots and percentiles are shown below. 

 <table>
    <tr>
      <th>N_knots</th>
      <th>Percentile</th>
    </tr>
    <tr>
      <td>3</td>
      <td>.10, .50, .90</td>
    </tr>
    <tr>
      <td>4</td>
      <td>.05, .35, .65, .95</td>
    </tr>
    <tr>
      <td>5</td>
      <td>.05, .275, .50, .725, .95</td>
    </tr>
    <tr>
      <td>6</td>
      <td>.05, .23, .41, .59, .77, .95</td>
    </tr>
    <tr>
      <td>7</td>
      <td>.025, .1833, .3417, .5, .6583, .8167,.975</td>
    </tr>
  </table>
  
<br>


If you would like to change n_knots and cutoff values, you give your own value. Here, we set 4 knots (20, 40, 60, 80 percentile of age).

<br>



![image](https://user-images.githubusercontent.com/19466700/223550837-f709345e-6c9e-49f8-bd0d-dedd0d494730.png)

<br>

## 3. Changes the reference points (48.8 -> 60.0 yrs)
In default settings, the reference value of rcs is set median of exposure variable in R. If you would like to change the reference value, you can define by chaning the setting of datadist. Here, we set 60 yrs as a reference instead of 48.8 yrs.

<br>

![image](https://user-images.githubusercontent.com/19466700/223553435-f323fabd-f364-45a0-94d2-542bc59ba14a.png)

<br>

## 4. Final version
The settings are defined as the following table.

<br>

 <table>
    <tr>
      <th>Parameters</th>
      <th>Values</th>
    </tr>
    <tr>
      <td>Reference</td>
      <td>50 yrs</td>
    </tr>
    <tr>
      <td>N_knots</td>
      <td>4</td>
    </tr>
    <tr>
      <td>Points</td>
      <td>35, 40, 60, 65</td>
    </tr>
  </table>

<br>

![image](https://user-images.githubusercontent.com/19466700/223557644-eee78933-321e-4ecf-9ab1-e8030f541aac.png)

<br>

## 5. Questions/Bugs
If you find any mistakes/bugs on this page and code, please contact me via e-mail.

<b>Ryosuke FUJII, PhD</b><br>
Eurac Research 🍕 /Fujita Health University　🍣 <br>
rfujii [at] fujita-hu.ac.jp
