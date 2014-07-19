      program critical_nested
          integer :: me

          me = this_image()


          critical
            print *, me, ": in critical section (entry)"
            call sleep(2)

            ! this should be a compiler error
            critical
            print *, me, ": nested critical region"
            end critical 

            print *, me, ": in critical section (exit)"
            call flush(6)
          end critical

          
      end program
