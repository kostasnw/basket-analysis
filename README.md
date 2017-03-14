# BasketAnalysis

Basket Analysis Package using a-priori algorithm.

## Output columns
- Product Set (x -> y)
- Support (as %)
- Confidence (as %)
- Lift

## Lift measurement
Lift is defined as the importance of the calculated confidence. It takes into consideration how frequently the given item appears in baskets (an item that appears in many baskets is most likely to have many false associations)
### Value interpretation:
- **value less than 1:** negative association (if item x is bought item y is unlikely to be bought)
- **value equals to 1:** no association between items
- **value greater than 1:** correct association (if item x is bought item y is likely to be bought)

## Usage
inside the directory of the downloaded package run
```sh
./basket_analysis -S "/path/to/items.csv" -t "/path/to/output.csv" -s 0.015
```

Options:
- **-S** or **--source** indicates the csv file to use as source
- **-t** or **--target** indicates where to save the output
- **-s** or **--support** indicates the minimum support threshold for single items (e.g **0.02** -> 2%)

## Example CSV for input
You can find an example of how the input should be in **items.csv.example**