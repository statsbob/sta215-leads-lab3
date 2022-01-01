library(tidyverse)
load("colleges2.rda")


### 1. Summary Statistics
# The base R function summary() is one option for obtaining summary statitics. 
#   Let's run it on the variable `netprice` to see it in action. 
#   Recall, to refer to a particular variable you use the <dataframe>$<variable>. 

summary(colleges2$netprice)


# Skim (from skimr package) provides a nice summary of quantitative variables.
# Here we'll run it separately on variables with "big numbers" and those that 
# are percents. If run altogether, the formatting is cumbersome in the console 
# window. Run these three commands.
library(skimr)
skim(colleges2, UGDS, netprice, SAT_AVG, GRAD_DEBT_MDN, FAMINC, MD_EARN_WNE_P10)
skim(colleges2, ADM_RATE, RET_FT4, GradRate8yr, PCTPELL, PCTFLOAN, FIRST_GEN, GT_28K_P10)


# In RMarkdown, it looks fine to have all the variables together, as long as we
#   lump the "big number" variables together and then the percentage variables.
# Copy this version into the Rmarkdown file. Run it here if you want to see what
#   I meant by cumbersome. 
skim(colleges2, UGDS, netprice, SAT_AVG, GRAD_DEBT_MDN, FAMINC, MD_EARN_WNE_P10
     , ADM_RATE, RET_FT4, GradRate8yr, PCTPELL, PCTFLOAN, FIRST_GEN, GT_28K_P10)


## 2. Histogram of Net Price. 
# First, run the code provided below which is base syntax for making a histogram
# A few notes about this code:
#   - The first argument is always the dataframe to run the function on.
#   - The variable netprice gets mapped to the x-axis in the ggplot() function. 
#      That mapping applies to the entire graph, so it can be placed in the ggplot() function. 
#   - geom_histogram() adds a layer to the plot (a histogram). The preceding 
#      line MUST HAVE A + SIGN.

ggplot(colleges2, aes(x=netprice)) +
  geom_histogram()


# CHANGE 1
# By default, ggplot2 will choose a binwidth for your histogram that results in about 30 bins. 
# You can set the binwidth manually with the binwidth argument, which is interpreted 
#   in the units of the x axis. 
# ADD `binwidth=2500` to the geom_histogram() function in the code above. Add an 
#   answer in the Rmarkdown document.

# CHANGE 2
# Now add the argument `color="black"` (after a comma) and run it again. Add an 
#   answer in the Rmarkdown document.

# CHANGE 3
# Finally, add `fill="lightblue"`. Then copy the command and paste it into the
#   R Markdown document. 


## 3. Net Price vs Type of Institution 
# The code below differs from the one above in that the fill argument got moved 
#   to the mapping aesthetic and is set to a variable (control).  As a result, 
#  separate histograms will be displayed for the two levels of that variable.
ggplot(colleges2, aes(x=netprice, fill=control)) +
  geom_histogram(binwidth=2500, color="black")


## Panels are referred to as a *facets* in the ggplot2 *grammar of graphics*. 
## Facet_grid() says to facet into rows based on control. 
##    (If you used . ~ control, there would be two columns instead.) 
ggplot(colleges2, aes(x=netprice)) +
  geom_histogram(binwidth=2500, color="black", fill="lightblue") +
  facet_grid(control ~ .)


## 4. Boxplot of number of degree-seeking undergraduate students by type of institution

## The aesthetic below maps the categorical variable control to the x-axis, and 
##    the quantitative variable UGDS to the y-axis. That with the subsequent 
##    boxplot command creates a comparative boxplot. 
ggplot(colleges2, aes(x=control, y=UGDS)) +
  geom_boxplot()


## 5. 10 Largest Private Universities by Number of Undergraduates 
# The series of commands below are to introduce you to DPLYR, the tidyverse 
#   package for manipulating data. Go through the commands one at a time to 
#   learn the fundamentals of this important package.

# The filter() function is used to filter rows by some criteria. It's important
#   to observe that for every tidyverse function, the first argument is the name 
#   of the dataframe. The second argument is an expression for filtering rows.
#   Only rows for which that is true will be included.
# Here, the filtered results are saved to a dataframe named big_private. 
#   Run the command and just compare the number of observations and variables
#   to that of colleges2 by looking in the Environment panel to the top-right. 
big_private <- filter(colleges2, control=="Private")

# Now we'll alter the above command to use the pipe operator: %>%, which says to 
#   take the previous results and "pipe" them into another function as the first
#   argument (the dataframe). So this says to start with colleges2, then filter
#   the rows. 
big_private <- colleges2 %>% 
  filter(control=="Private")

# The select function is for subsetting columns (variables). So start with 
#   colleges2, filter the rows, then only keep those 2 columns. 
big_private <- colleges2 %>% 
  filter(control=="Private") %>%
  select(INSTNM, UGDS)

# Slice_max selects the rows with the 10 highest values on that variable. Now 
#   we've arrived at our desired command. COPY this and the View command that 
#   follows into your R Markdown document.
big_private <- colleges2 %>% 
  filter(control=="Private") %>%
  select(INSTNM, UGDS) %>%
  slice_max(UGDS, n=10) 
big_private


#### Explore Colleges & Universities in Michigan

## 6. Create a data frame of MI schools

# MODIFY the assignment command below, adding DPLYR functions one-at-a-time 
#   (don't forget the pipe operator each time). Run the command after each 
#   modification and observe how the number of observations and variables changes.  
#   Use the above example to guide you.
# a. Add a function to only keep rows for which STABBR is MI. 
# b. add a function to only keep the following variables:
#       INSTNM, control, netprice, ACTCMMID, RET_FT4, GradRate8yr, FIRST_GEN
# c. add one more DYPLYR function at the end to sort the table:
#       arrange(control, INSTNM) 
MIcolleges <- colleges2

# Once your MIcolleges table has 43 obs and 7 variables, run this to view it.
#   If it looks right, COPY the above command into R Markdown.
MIcolleges


## 7. Histogram of Average Net Price. Add a reference line for GVSU 

# The first command below creates a one-row data frame for GVSU. The second 
#   extracts the value for netprice. Run them to both to see.
GV <- filter(MIcolleges, INSTNM=="Grand Valley State University") 
GV$netprice

# The code below was copied from problem 2 above and modified to run on the 
#  new data frame. 
# NOTICE the GEOM_VLINE() function added a vertical line to the graph space,
#   and the horizontal location (xintercept - location on the x-axis) is set to 
#   be the value examined above.
ggplot(MIcolleges, aes(x=netprice)) +
  geom_histogram(binwidth = 2500, color="black", fill="lightblue") +
  geom_vline(xintercept=GV$netprice, color="darkblue", linetype="dashed", size=1)



## 8. Explore Net Price by Control - boxplots and beyond

# This code for producing a basic boxplot using geom_boxplot.
ggplot(MIcolleges, aes(x=control, y=netprice)) +
  geom_boxplot()

# The dotplot geom places a marker for every value (useful for "smallish" data sets)
#   The binaxis argument sets which axis is the numeric one (the binning axis).
#   After running this and viewing the plot. Try it with and without the 
#   stackdir="center" argument to see what that does.
ggplot(MIcolleges, aes(x=control, y=netprice)) +
  geom_dotplot(binaxis="y", stackdir="center")

# Now run the code below to produce a violin plot. It creates a "smoothed" version 
#   of the previous dot-plot, showing the relative density over the range of 
#   observed values. 
ggplot(MIcolleges, aes(x=control, y=netprice)) +
  geom_violin()

# Now we'll spice up the violins by adding the parameter draw_quantiles, to which
#   we'll pass a vector of values resulting in the 25th, 50th and 75th percentiles
#   being drawn. 
# Add to this plot a horizontal line for the netprice of GVSU. Copy the  
#   geom_vline function from problem 7 (& don't forget a plus). Identify two 
#   modifications that must be made to make this a horizontal line instead of 
#   vertical and located in the right place on the y-axis.
# COPY this command into your R Markdown file. 
ggplot(MIcolleges, aes(x=control, y=netprice)) +
  geom_violin(draw_quantiles = c(0.25, 0.5, 0.75)) 
