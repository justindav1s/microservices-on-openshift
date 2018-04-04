import { Component, OnInit, EventEmitter, Output} from '@angular/core';

import { CategoriesService } from '../categories.service';
import { InventoryService } from '../inventory.service';
import { Product } from '../product';

@Component({
  selector: 'app-categories',
  templateUrl: './categories.component.html',
  styleUrls: ['./categories.component.css']
})
export class CategoriesComponent implements OnInit {

  @Output() productList = new EventEmitter<Product[]>();

  categories : string[];
  selectedCategory: string;
  productListAvailable = new EventEmitter<Product[]>();
  products: Product[];

  constructor
  (
    private categoriesService: CategoriesService,
    private inventoryService: InventoryService
  ) { }

  ngOnInit() {
    this.getCategories();
  }

  getCategories(): void {
    this.categoriesService.getCategories().subscribe(categories => this.categories = categories);
  }

  onClickCategory(category : string): void {
    this.selectedCategory = category;
    console.log("CategoriesComponent selected category : "+this.selectedCategory);
    this.getAllProductsForCategory(this.selectedCategory);
  }

  getAllProductsForCategory(category: string): void {
    console.log("InventoryComponent get inventory for category : " + category);
    this.inventoryService.getProductsByType(category).subscribe( (products: Product[]) => {
      console.log("CategoriesComponent : products : " + products);
      this.productList.emit(products);
      this.products = products;
    });
  }

}