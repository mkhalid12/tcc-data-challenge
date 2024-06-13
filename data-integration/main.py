from datetime import date
from jobs.raw_customers import RawCustomers
from jobs.raw_products import RawProducts
from jobs.raw_orders import RawOrders
from jobs.raw_order_positions import RawOrdersPositions
from jobs.raw_shops import RawShops
from jobs.sta_customers import StaCustomers
from jobs.sta_order_positions import StaOrderPositions
from jobs.sta_orders import StaOrders
from jobs.sta_products import StaProducts
from jobs.sta_shops import StaShops
from jobs.stg_fact_orders import StgFactOrders
from jobs.stg_fact_order_positions import StgFactOrderPositions
from jobs.stg_time import StgTime



def main():

    # checkpoint = str(date.today())
    checkpoint = '2020-01-01'

    print(f'Starting Pipeline for checkpoint {checkpoint} ')

    print('Starting Loading Raw (Bronze) Layer RawCustomers ')
    raw_customers = RawCustomers(checkpoint=checkpoint)
    raw_customers.run_wrapper()

    print('Starting Loading Raw (Bronze) Layer RawProducts ')
    raw_products = RawProducts(checkpoint=checkpoint)
    raw_products.run_wrapper()

    print('Starting Loading Raw (Bronze) Layer RawOrdersPositions ')
    raw_order_positions=RawOrdersPositions(checkpoint=checkpoint)
    raw_order_positions.run_wrapper()

    print('Starting Loading Raw (Bronze) Layer RawOrders ')
    raw_orders=RawOrders(checkpoint=checkpoint)
    raw_orders.run_wrapper()

    print('Starting Loading Raw (Bronze) Layer RawShops ')
    raw_orders = RawShops(checkpoint=checkpoint)
    raw_orders.run_wrapper()

    print('Starting Loading Raw (Silver) Layer StaCustomers ')
    sta_customers = StaCustomers(checkpoint=checkpoint)
    sta_customers.run_wrapper()

    print('Starting Loading Raw (Silver) Layer StaOrderPositions ')
    sta_order_positions = StaOrderPositions(checkpoint=checkpoint)
    sta_order_positions.run_wrapper()

    print('Starting Loading Raw (Silver) Layer StaOrders ')
    sta_orders = StaOrders(checkpoint=checkpoint)
    sta_orders.run_wrapper()

    print('Starting Loading Raw (Silver) Layer StaProducts ')
    sta_products = StaProducts(checkpoint=checkpoint)
    sta_products.run_wrapper()

    print('Starting Loading Raw (Silver) Layer StaShops ')
    sta_shops = StaShops(checkpoint=checkpoint)
    sta_shops.run_wrapper()

    print('Starting Loading Raw (Gold) Layer StgFactOrders ')
    sta_fact_orders = StgFactOrders(checkpoint=checkpoint)
    sta_fact_orders.run_wrapper()

    print('Starting Loading Raw (Gold) Layer StgFactOrderPositions ')
    sta_fact_order_positions = StgFactOrderPositions(checkpoint=checkpoint)
    sta_fact_order_positions.run_wrapper()

    print('Starting Loading Raw (Gold) Layer StgTime ')
    sta_time = StgTime(checkpoint=checkpoint)
    sta_time.run_wrapper()

    print(f'Data Integration Completed for checkpoint {checkpoint}')


if __name__ == '__main__':
    main()
