import { Injectable } from '@angular/core';

import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Observable } from 'rxjs/Observable';
import { of } from 'rxjs/observable/of';
import { catchError, map, tap } from 'rxjs/operators';

import { Basket } from './basket';
import { Product } from './product';

const httpOptions = {
  headers: new HttpHeaders({ 'Content-Type': 'application/json' })
};

@Injectable()
export class BasketService {

  private basketUrl = 'http://basket-amazin-dev.apps.ocp.datr.eu/basket/';

  constructor(private http: HttpClient) { }

  createBasket(): Observable<Basket> {
    console.log("BasketService creating basket");
    const url = `${this.basketUrl}/create`;
    return this.http.get<Basket>(url)
    .pipe(
      tap(_ => this.log(`fetched basket`)),
      catchError(this.handleError<Basket>(`createBasket`))
    );
  }

  addProductToBasket(product: Product): Observable<Basket> {
    console.log("addProductToBasket");
    const url = `${this.basketUrl}/create`;
    return this.http.get<Basket>(url)
    .pipe(
      tap(_ => this.log(`fetched basket`)),
      catchError(this.handleError<Basket>(`createBasket`))
    );
  }

  /**
   * Handle Http operation that failed.
   * Let the app continue.
   * @param operation - name of the operation that failed
   * @param result - optional value to return as the observable result
   */
  private handleError<T> (operation = 'operation', result?: T) {
    return (error: any): Observable<T> => {

      // TODO: send the error to remote logging infrastructure
      console.error(error); // log to console instead

      // TODO: better job of transforming error for user consumption
      this.log(`${operation} failed: ${error.message}`);

      // Let the app keep running by returning an empty result.
      return of(result as T);
    };
  }

  /** Log a HeroService message with the MessageService */
  private log(message: string) {
    console.log('BasketService: ' + message);
  }
}
